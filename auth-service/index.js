const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());

// In-memory user store for prototype
const users = [];

app.get('/', (req, res) => {
    res.send('Auth Service is running');
});

// Register
app.post('/auth/register', (req, res) => {
    const { email, password, name } = req.body;
    if (users.find(u => u.email === email)) {
        return res.status(400).json({ message: 'User already exists' });
    }
    const newUser = { id: users.length + 1, email, password, name, bio: '' };
    users.push(newUser);
    res.status(201).json({ message: 'User registered successfully', user: { id: newUser.id, email: newUser.email, name: newUser.name } });
});

// Login
app.post('/auth/login', (req, res) => {
    const { email, password } = req.body;
    const user = users.find(u => u.email === email && u.password === password);
    if (!user) {
        return res.status(401).json({ message: 'Invalid credentials' });
    }
    // Mock token
    res.json({ token: `mock-token-${user.id}`, user: { id: user.id, email: user.email, name: user.name } });
});

// Profile
app.get('/users/profile', (req, res) => {
    const userId = parseInt(req.query.id);
    const user = users.find(u => u.id === userId);
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json(user);
});

// Update Profile
app.put('/users/profile', (req, res) => {
    const { id, bio, password } = req.body;
    const userIndex = users.findIndex(u => u.id === id);
    if (userIndex === -1) return res.status(404).json({ message: 'User not found' });
    
    if (bio) users[userIndex].bio = bio;
    if (password) users[userIndex].password = password;
    
    res.json({ message: 'Profile updated', user: users[userIndex] });
});

app.listen(PORT, () => {
    console.log(`Auth Service running on port ${PORT}`);
});
