class Config {
  // Use 10.0.2.2 for Android Emulator to access localhost
  // For Chrome/Web, change to 'http://localhost'
  
  // Auth Service (Node.js)
  static const String baseUrlAuth = 'http://10.0.2.2:3001';
  
  // Content Service (PHP) - Novels & Chapters
  static const String baseUrlNovel = 'http://10.0.2.2:8000';
  
  // Interaction Service (Python/Flask) - Comments
  static const String baseUrlInteraction = 'http://10.0.2.2:5000';
  
  // Collection Service (Node.js) - User Favorites
  static const String baseUrlCollection = 'http://10.0.2.2:3002';
}
