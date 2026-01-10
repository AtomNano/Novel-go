-- Novel Platform Database Initialization
-- Creating all tables for the microservices

-- Users table (for Auth Service)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    profile_photo VARCHAR(500) DEFAULT NULL,
    address TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Novels table (for Content Service)
CREATE TABLE IF NOT EXISTS novels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publisher VARCHAR(255) NOT NULL,
    cover VARCHAR(500) DEFAULT 'https://via.placeholder.com/300x400',
    content TEXT NOT NULL,
    description TEXT DEFAULT NULL,
    published_date DATE DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Novel views tracking
CREATE TABLE IF NOT EXISTS novel_views (
    id INT AUTO_INCREMENT PRIMARY KEY,
    novel_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (novel_id) REFERENCES novels(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_novel_views (novel_id)
);

-- Comments table (for Interaction Service)
CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    novel_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (novel_id) REFERENCES novels(id) ON DELETE CASCADE,
    INDEX idx_comments_novel (novel_id),
    INDEX idx_comments_user (user_id)
);

-- Favorites/Collections table (for Collection Service)
CREATE TABLE IF NOT EXISTS favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    novel_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (novel_id) REFERENCES novels(id) ON DELETE CASCADE,
    UNIQUE KEY unique_favorite (user_id, novel_id),
    INDEX idx_favorites_user (user_id),
    INDEX idx_favorites_novel (novel_id)
);

-- Insert default admin user
-- Note: These are placeholder hashes. For production, use proper bcrypt hashes.
-- Password for all users: "password123"
-- You should register users through the API for proper password hashing
INSERT INTO users (name, email, password, role, address) VALUES 
('Admin User', 'admin@novel.com', '$2b$10$rZ8L8qY5Z5Z5Z5Z5Z5Z5ZuN7vPGxg5qYxZ5Z5Z5Z5Z5Z5Z5Z5Z5Zu', 'admin', 'Admin Office'),
('John Doe', 'john@example.com', '$2b$10$rZ8L8qY5Z5Z5Z5Z5Z5Z5ZuN7vPGxg5qYxZ5Z5Z5Z5Z5Z5Z5Z5Z5Zu', 'user', 'Jakarta, Indonesia'),
('Jane Smith', 'jane@example.com', '$2b$10$rZ8L8qY5Z5Z5Z5Z5Z5Z5ZuN7vPGxg5qYxZ5Z5Z5Z5Z5Z5Z5Z5Z5Zu', 'user', 'Bandung, Indonesia');

-- Insert sample novels
INSERT INTO novels (title, author, publisher, content, description, published_date) VALUES 
(
    'The Beginning After The End',
    'TurtleMe',
    'Tapas Media',
    'King Grey has unrivaled strength, wealth, and prestige in a world governed by martial ability. However, solitude lingers closely behind those with great power. Beneath the glamorous exterior of a powerful king lurks the shell of man, devoid of purpose and will.\n\nReincarnated into a new world filled with magic and monsters, the king has a second chance to relive his life. Correcting the mistakes of his past will not be his only challenge, however. Underneath the peace and prosperity of the new world is an undercurrent threatening to destroy everything he has worked for, questioning his role and reason for being born again.\n\nChapter 1: The End and a New Beginning\n\nAs I stood at the precipice of my final battle, I couldn''t help but reflect on the life I had lived. A life of power, yes, but also one of loneliness and regret. The sword in my hand felt heavier than ever before...',
    'A story of reincarnation and second chances in a magical world.',
    '2016-07-04'
),
(
    'Solo Leveling',
    'Chugong',
    'D&C Media',
    'Ten years ago, "the Gate" appeared and connected the real world with the realm of magic and monsters. To combat these vile beasts, ordinary people received superhuman powers and became known as "Hunters." Twenty-year-old Sung Jin-Woo is one such Hunter, but he is known as the "World''s Weakest," owing to his pathetic power compared to even a measly E-Rank. Still, he hunts monsters tirelessly in low-rank Gates to pay for his mother''s medical bills.\n\nChapter 1: The Double Dungeon\n\nThe stench of blood filled the air as our raid party carefully made our way through the dark corridor. As an E-Rank hunter, I was essentially just here to make up the numbers. My role was simple: don''t die and try not to get in the way of the stronger hunters...',
    'From the weakest hunter to the strongest - a story of growth and determination.',
    '2016-07-25'
),
(
    'Omniscient Reader''s Viewpoint',
    'Sing Shong',
    'Munpia',
    'Dokja was an average office worker whose sole interest was reading his favorite web novel ''Three Ways to Survive the Apocalypse.'' But when the novel suddenly becomes reality, he is the only person who knows how the world will end. Armed with this realization, Dokja uses his understanding to change the course of the story, and the world, as he knows it.\n\nChapter 1: The Last Reader\n\nI was reading the final chapter of my favorite novel on the subway. "Three Ways to Survive the Apocalypse" - a story that had accompanied me for over ten years. I was the only reader who stayed until the very end. And then, as if on cue, the world around me began to change...',
    'What if the novel you''ve been reading becomes reality?',
    '2018-01-06'
),
(
    'Trash of the Count''s Family',
    'Yoo Ryeo Han',
    'Munpia',
    'When I opened my eyes, I was inside a novel. The protagonist of the novel, Choi Han, goes to destroy the world. I became a minor character, Cale Henituse, who is a member of a wealthy family that the protagonist passes by. The problem is that Cale Henituse is destined to become trash. I decided to quietly live a peaceful life.\n\nChapter 1: A Comfortable Life\n\nMy goal was simple: avoid the protagonist, live quietly, and enjoy the wealth of the Count''s family. But somehow, I keep getting involved in major events. Maybe I should''ve read the novel more carefully...',
    'Sometimes being "trash" is the perfect cover for saving the world.',
    '2018-02-27'
),
(
    'The Legendary Moonlight Sculptor',
    'Nam Heesung',
    'Munpia',
    'The man forsaken by the world, the man a slave to money and the man known as the legendary God of War in the highly popular MMORPG Continent of Magic. With the coming of age, he decides to say goodbye, but the feeble attempt to earn a little something for his time and effort ripples into an effect none could ever have imagined.\n\nChapter 1: A New Beginning\n\nAfter selling my character for an astronomical sum, I thought my gaming days were over. I needed to support my family, pay off our debts. But when I discovered Royal Road, a new virtual reality game, I saw another opportunity. This time, I would play differently. This time, I would become a sculptor...',
    'Carving a path to glory in the virtual world.',
    '2007-01-12'
);

-- Insert sample views for novels
INSERT INTO novel_views (novel_id, user_id) VALUES 
(1, 2), (1, 3), (1, NULL), (1, NULL), (1, NULL),
(2, 2), (2, 3), (2, NULL), (2, NULL),
(3, 2), (3, NULL), (3, NULL),
(4, 3), (4, NULL),
(5, NULL);

-- Insert sample comments
INSERT INTO comments (user_id, novel_id, content) VALUES 
(2, 1, 'Amazing story! The world-building is incredible.'),
(3, 1, 'I love the character development in this novel.'),
(2, 2, 'The progression system is so satisfying to read!'),
(3, 3, 'This is my favorite novel of all time!'),
(2, 4, 'Cale is such a great protagonist, love his personality.');

-- Insert sample favorites
INSERT INTO favorites (user_id, novel_id) VALUES 
(2, 1),
(2, 2),
(2, 3),
(3, 1),
(3, 3),
(3, 4);
