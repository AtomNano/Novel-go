const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3002;

app.use(cors());
app.use(express.json());

// In-memory collection store
// Structure: { userId: 1, novelId: 101, status: 'Reading' }
let myLibrary = [];

app.get('/', (req, res) => {
    res.send('Collection Service is running');
});

// Add to Library (Create)
app.post('/library', (req, res) => {
    const { userId, novelId, status } = req.body;
    // Check if duplicate
    if (myLibrary.find(item => item.userId === userId && item.novelId === novelId)) {
        return res.status(400).json({ message: 'Novel already in library' });
    }
    const newItem = { id: myLibrary.length + 1, userId, novelId, status: status || 'Reading' };
    myLibrary.push(newItem);
    res.status(201).json(newItem);
});

// Get User's Library (Read)
app.get('/library/:userId', (req, res) => {
    const userId = parseInt(req.params.userId);
    const userLibrary = myLibrary.filter(item => item.userId === userId);
    res.json(userLibrary);
});

// Update Status (Update)
app.put('/library/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const { status } = req.body;
    const index = myLibrary.findIndex(item => item.id === id);
    if (index === -1) return res.status(404).json({ message: 'Item not found' });

    myLibrary[index].status = status;
    res.json(myLibrary[index]);
});

// Remove from Library (Delete)
app.delete('/library/:id', (req, res) => {
    const id = parseInt(req.params.id);
    myLibrary = myLibrary.filter(item => item.id !== id);
    res.json({ message: 'Removed from library' });
});

app.listen(PORT, () => {
    console.log(`Collection Service running on port ${PORT}`);
});
