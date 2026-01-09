from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# In-memory storage
comments = []

@app.route('/')
def home():
    return "Interaction Service is running (Python)"

# Create Comment
@app.route('/comments', methods=['POST'])
def add_comment():
    data = request.json
    comment = {
        'id': len(comments) + 1,
        'user_id': data.get('user_id'),
        'novel_id': data.get('novel_id'),
        'content': data.get('content')
    }
    comments.append(comment)
    return jsonify(comment), 201

# Read Comments for a Novel
@app.route('/comments/novel/<int:novel_id>', methods=['GET'])
def get_comments(novel_id):
    novel_comments = [c for c in comments if c['novel_id'] == novel_id]
    return jsonify(novel_comments)

# Update Comment
@app.route('/comments/<int:comment_id>', methods=['PUT'])
def update_comment(comment_id):
    data = request.json
    for comment in comments:
        if comment['id'] == comment_id:
            comment['content'] = data.get('content')
            return jsonify(comment)
    return jsonify({'error': 'Comment not found'}), 404

# Delete Comment
@app.route('/comments/<int:comment_id>', methods=['DELETE'])
def delete_comment(comment_id):
    global comments
    comments = [c for c in comments if c['id'] != comment_id]
    return jsonify({'message': 'Comment deleted'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
