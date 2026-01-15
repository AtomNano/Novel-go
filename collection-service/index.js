const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
const PORT = 3002;

app.use(cors());
app.use(express.json());

// Database configuration
const dbConfig = {
    host: process.env.DB_HOST || 'mysql',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'novel_user',
    password: process.env.DB_PASSWORD || 'novel_password',
    database: process.env.DB_DATABASE || 'novel_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
};

// Create connection pool
let pool;

async function initDatabase() {
    try {
        pool = mysql.createPool(dbConfig);
        console.log('Database connection pool created');

        // Test connection
        const connection = await pool.getConnection();
        console.log('✓ Connected to MySQL database');
        connection.release();
    } catch (error) {
        console.error('Database connection error:', error);
        setTimeout(initDatabase, 5000); // Retry after 5 seconds
    }
}

initDatabase();

// Health check
app.get('/', (req, res) => {
    res.json({
        service: 'Collection Service',
        status: 'running',
        database: pool ? 'connected' : 'disconnected'
    });
});

// Get User's Favorites
app.get('/favorites/:userId', async (req, res) => {
    try {
        const userId = parseInt(req.params.userId);

        const [favorites] = await pool.query(`
            SELECT f.id, f.novel_id, f.created_at,
                   n.title, n.description,
                   COUNT(DISTINCT nv.id) as view_count
            FROM favorites f
            JOIN novels n ON f.novel_id = n.id
            LEFT JOIN novel_views nv ON n.id = nv.novel_id
            WHERE f.user_id = ?
            GROUP BY f.id, f.novel_id, f.created_at, n.id
            ORDER BY f.created_at DESC
        `, [userId]);

        // Convert view_count to integer
        favorites.forEach(fav => {
            fav.view_count = parseInt(fav.view_count) || 0;
        });

        res.json(favorites);
    } catch (error) {
        console.error('Get favorites error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Add to Favorites
app.post('/favorites', async (req, res) => {
    try {
        const { userId, novelId } = req.body;

        if (!userId || !novelId) {
            return res.status(400).json({ message: 'userId and novelId are required' });
        }

        // Check if already favorited
        const [existing] = await pool.query(
            'SELECT id FROM favorites WHERE user_id = ? AND novel_id = ?',
            [userId, novelId]
        );

        if (existing.length > 0) {
            return res.status(400).json({ message: 'Novel already in favorites' });
        }

        // Check if novel exists
        const [novels] = await pool.query(
            'SELECT id FROM novels WHERE id = ?',
            [novelId]
        );

        if (novels.length === 0) {
            return res.status(404).json({ message: 'Novel not found' });
        }

        // Add to favorites
        const [result] = await pool.query(
            'INSERT INTO favorites (user_id, novel_id) VALUES (?, ?)',
            [userId, novelId]
        );

        // Get the created favorite with novel info
        const [favorite] = await pool.query(`
            SELECT f.id, f.novel_id, f.created_at,
                   n.title, n.description
            FROM favorites f
            JOIN novels n ON f.novel_id = n.id
            WHERE f.id = ?
        `, [result.insertId]);

        res.status(201).json({
            message: 'Added to favorites',
            favorite: favorite[0]
        });
    } catch (error) {
        console.error('Add favorite error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Remove from Favorites
app.delete('/favorites/:id', async (req, res) => {
    try {
        const favoriteId = parseInt(req.params.id);

        const [result] = await pool.query(
            'DELETE FROM favorites WHERE id = ?',
            [favoriteId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Favorite not found' });
        }

        res.json({ message: 'Removed from favorites' });
    } catch (error) {
        console.error('Remove favorite error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Remove by User ID and Novel ID
app.delete('/favorites/user/:userId/novel/:novelId', async (req, res) => {
    try {
        const userId = parseInt(req.params.userId);
        const novelId = parseInt(req.params.novelId);

        const [result] = await pool.query(
            'DELETE FROM favorites WHERE user_id = ? AND novel_id = ?',
            [userId, novelId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Favorite not found' });
        }

        res.json({ message: 'Removed from favorites' });
    } catch (error) {
        console.error('Remove favorite error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Get Users Who Favorited a Novel (Admin)
app.get('/favorites/novel/:novelId/users', async (req, res) => {
    try {
        const novelId = parseInt(req.params.novelId);

        const [users] = await pool.query(`
            SELECT u.id, u.name, u.email, f.created_at as favorited_at
            FROM favorites f
            JOIN users u ON f.user_id = u.id
            WHERE f.novel_id = ?
            ORDER BY f.created_at DESC
        `, [novelId]);

        res.json(users);
    } catch (error) {
        console.error('Get favoriting users error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

app.listen(PORT, () => {
    console.log(`Collection Service running on port ${PORT}`);
});
