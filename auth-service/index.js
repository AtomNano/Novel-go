const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

const app = express();
const PORT = 3001;

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

const JWT_SECRET = process.env.JWT_SECRET || 'your_jwt_secret_key';

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
        service: 'Auth Service',
        status: 'running',
        database: pool ? 'connected' : 'disconnected'
    });
});

// Register
app.post('/auth/register', async (req, res) => {
    try {
        const { email, password, name, address } = req.body;

        if (!email || !password || !name) {
            return res.status(400).json({ message: 'Email, password, and name are required' });
        }

        // Check if user already exists
        const [existingUsers] = await pool.query(
            'SELECT id FROM users WHERE email = ?',
            [email]
        );

        if (existingUsers.length > 0) {
            return res.status(400).json({ message: 'User already exists' });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Insert new user
        const [result] = await pool.query(
            'INSERT INTO users (name, email, password, role, address) VALUES (?, ?, ?, ?, ?)',
            [name, email, hashedPassword, 'user', address || null]
        );

        res.status(201).json({
            message: 'User registered successfully',
            user: {
                id: result.insertId,
                email,
                name,
                role: 'user'
            }
        });
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ message: 'Server error during registration' });
    }
});

// Login
app.post('/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        // Find user
        const [users] = await pool.query(
            'SELECT * FROM users WHERE email = ?',
            [email]
        );

        if (users.length === 0) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const user = users[0];

        // Compare password
        const isPasswordValid = await bcrypt.compare(password, user.password);

        if (!isPasswordValid) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        // Generate JWT token
        const token = jwt.sign(
            { id: user.id, email: user.email, role: user.role },
            JWT_SECRET,
            { expiresIn: '24h' }
        );

        res.json({
            token,
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role,
                profile_photo: user.profile_photo,
                address: user.address
            }
        });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ message: 'Server error during login' });
    }
});

// Get Profile
app.get('/users/profile/:id', async (req, res) => {
    try {
        const userId = parseInt(req.params.id);

        const [users] = await pool.query(
            'SELECT id, name, email, role, profile_photo, address, created_at FROM users WHERE id = ?',
            [userId]
        );

        if (users.length === 0) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.json(users[0]);
    } catch (error) {
        console.error('Get profile error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Update Profile
app.put('/users/profile/:id', async (req, res) => {
    try {
        const userId = parseInt(req.params.id);
        const { name, email, password, profile_photo, address } = req.body;

        // Build dynamic update query
        let updateFields = [];
        let updateValues = [];

        if (name) {
            updateFields.push('name = ?');
            updateValues.push(name);
        }
        if (email) {
            updateFields.push('email = ?');
            updateValues.push(email);
        }
        if (password) {
            const hashedPassword = await bcrypt.hash(password, 10);
            updateFields.push('password = ?');
            updateValues.push(hashedPassword);
        }
        if (profile_photo) {
            updateFields.push('profile_photo = ?');
            updateValues.push(profile_photo);
        }
        if (address !== undefined) {
            updateFields.push('address = ?');
            updateValues.push(address);
        }

        if (updateFields.length === 0) {
            return res.status(400).json({ message: 'No fields to update' });
        }

        updateValues.push(userId);

        await pool.query(
            `UPDATE users SET ${updateFields.join(', ')} WHERE id = ?`,
            updateValues
        );

        // Get updated user
        const [users] = await pool.query(
            'SELECT id, name, email, role, profile_photo, address FROM users WHERE id = ?',
            [userId]
        );

        res.json({
            message: 'Profile updated successfully',
            user: users[0]
        });
    } catch (error) {
        console.error('Update profile error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Delete Account
app.delete('/users/:id', async (req, res) => {
    try {
        const userId = parseInt(req.params.id);

        const [result] = await pool.query(
            'DELETE FROM users WHERE id = ?',
            [userId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'User not found' });
        }

        res.json({ message: 'Account deleted successfully' });
    } catch (error) {
        console.error('Delete account error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Get All Users (Admin)
app.get('/users', async (req, res) => {
    try {
        const [users] = await pool.query(
            'SELECT id, name, email, role, profile_photo, address, created_at FROM users ORDER BY created_at DESC'
        );

        res.json(users);
    } catch (error) {
        console.error('Get all users error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

// Get User's Favorites Count
app.get('/users/:id/favorites-count', async (req, res) => {
    try {
        const userId = parseInt(req.params.id);

        const [result] = await pool.query(
            'SELECT COUNT(*) as count FROM favorites WHERE user_id = ?',
            [userId]
        );

        res.json({ count: result[0].count });
    } catch (error) {
        console.error('Get favorites count error:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

app.listen(PORT, () => {
    console.log(`Auth Service running on port ${PORT}`);
});
