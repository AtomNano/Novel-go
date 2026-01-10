from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
from mysql.connector import pooling
import os

app = Flask(__name__)
CORS(app)

# Database configuration
db_config = {
    'host': os.getenv('DB_HOST', 'mysql'),
    'port': int(os.getenv('DB_PORT', 3306)),
    'user': os.getenv('DB_USER', 'novel_user'),
    'password': os.getenv('DB_PASSWORD', 'novel_password'),
    'database': os.getenv('DB_DATABASE', 'novel_db'),
    'pool_name': 'interaction_pool',
    'pool_size': 5
}

# Create connection pool
try:
    connection_pool = mysql.connector.pooling.MySQLConnectionPool(**db_config)
    print('✓ MySQL connection pool created')
except mysql.connector.Error as err:
    print(f'Database connection error: {err}')
    connection_pool = None

def get_db_connection():
    """Get a connection from the pool"""
    if connection_pool:
        return connection_pool.get_connection()
    return None

@app.route('/')
def home():
    return jsonify({
        'service': 'Interaction Service',
        'status': 'running',
        'database': 'connected' if connection_pool else 'disconnected'
    })

# Get Comments for a Novel
@app.route('/comments/novel/<int:novel_id>', methods=['GET'])
def get_comments_by_novel(novel_id):
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cursor = conn.cursor(dictionary=True)
        cursor.execute('''
            SELECT c.*, u.name as user_name, u.email as user_email
            FROM comments c
            JOIN users u ON c.user_id = u.id
            WHERE c.novel_id = %s
            ORDER BY c.created_at DESC
        ''', (novel_id,))
        
        comments = cursor.fetchall()
        cursor.close()
        conn.close()
        
        # Convert datetime to string
        for comment in comments:
            comment['created_at'] = str(comment['created_at']) if comment['created_at'] else None
            comment['updated_at'] = str(comment['updated_at']) if comment['updated_at'] else None
        
        return jsonify(comments)
    except mysql.connector.Error as err:
        return jsonify({'error': 'Database error', 'message': str(err)}), 500

# Get All Comments (Admin)
@app.route('/comments', methods=['GET'])
def get_all_comments():
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cursor = conn.cursor(dictionary=True)
        cursor.execute('''
            SELECT c.*, u.name as user_name, u.email as user_email, n.title as novel_title
            FROM comments c
            JOIN users u ON c.user_id = u.id
            JOIN novels n ON c.novel_id = n.id
            ORDER BY c.created_at DESC
        ''')
        
        comments = cursor.fetchall()
        cursor.close()
        conn.close()
        
        # Convert datetime to string
        for comment in comments:
            comment['created_at'] = str(comment['created_at']) if comment['created_at'] else None
            comment['updated_at'] = str(comment['updated_at']) if comment['updated_at'] else None
        
        return jsonify(comments)
    except mysql.connector.Error as err:
        return jsonify({'error': 'Database error', 'message': str(err)}), 500

# Create Comment
@app.route('/comments', methods=['POST'])
def add_comment():
    try:
        data = request.json
        
        if not data or 'user_id' not in data or 'novel_id' not in data or 'content' not in data:
            return jsonify({'error': 'Missing required fields: user_id, novel_id, content'}), 400
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cursor = conn.cursor(dictionary=True)
        
        # Insert comment
        cursor.execute('''
            INSERT INTO comments (user_id, novel_id, content)
            VALUES (%s, %s, %s)
        ''', (data['user_id'], data['novel_id'], data['content']))
        
        conn.commit()
        comment_id = cursor.lastrowid
        
        # Fetch the created comment with user info
        cursor.execute('''
            SELECT c.*, u.name as user_name, u.email as user_email
            FROM comments c
            JOIN users u ON c.user_id = u.id
            WHERE c.id = %s
        ''', (comment_id,))
        
        comment = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if comment:
            comment['created_at'] = str(comment['created_at']) if comment['created_at'] else None
            comment['updated_at'] = str(comment['updated_at']) if comment['updated_at'] else None
        
        return jsonify(comment), 201
    except mysql.connector.Error as err:
        return jsonify({'error': 'Database error', 'message': str(err)}), 500

# Update Comment
@app.route('/comments/<int:comment_id>', methods=['PUT'])
def update_comment(comment_id):
    try:
        data = request.json
        
        if not data or 'content' not in data:
            return jsonify({'error': 'Missing required field: content'}), 400
        
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cursor = conn.cursor(dictionary=True)
        
        # Update comment
        cursor.execute('''
            UPDATE comments
            SET content = %s
            WHERE id = %s
        ''', (data['content'], comment_id))
        
        conn.commit()
        
        if cursor.rowcount == 0:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Comment not found'}), 404
        
        # Fetch updated comment
        cursor.execute('''
            SELECT c.*, u.name as user_name, u.email as user_email
            FROM comments c
            JOIN users u ON c.user_id = u.id
            WHERE c.id = %s
        ''', (comment_id,))
        
        comment = cursor.fetchone()
        cursor.close()
        conn.close()
        
        if comment:
            comment['created_at'] = str(comment['created_at']) if comment['created_at'] else None
            comment['updated_at'] = str(comment['updated_at']) if comment['updated_at'] else None
        
        return jsonify(comment)
    except mysql.connector.Error as err:
        return jsonify({'error': 'Database error', 'message': str(err)}), 500

# Delete Comment
@app.route('/comments/<int:comment_id>', methods=['DELETE'])
def delete_comment(comment_id):
    try:
        conn = get_db_connection()
        if not conn:
            return jsonify({'error': 'Database connection failed'}), 500
        
        cursor = conn.cursor()
        
        # Delete comment
        cursor.execute('DELETE FROM comments WHERE id = %s', (comment_id,))
        conn.commit()
        
        if cursor.rowcount == 0:
            cursor.close()
            conn.close()
            return jsonify({'error': 'Comment not found'}), 404
        
        cursor.close()
        conn.close()
        
        return jsonify({'message': 'Comment deleted successfully'})
    except mysql.connector.Error as err:
        return jsonify({'error': 'Database error', 'message': str(err)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
