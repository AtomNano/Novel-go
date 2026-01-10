<?php
// Content Service - Novel Management
// Handles all novel-related operations with MySQL database

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$uri = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

// Database configuration
$dbHost = getenv('DB_HOST') ?: 'mysql';
$dbPort = getenv('DB_PORT') ?: '3306';
$dbName = getenv('DB_DATABASE') ?: 'novel_db';
$dbUser = getenv('DB_USERNAME') ?: 'novel_user';
$dbPass = getenv('DB_PASSWORD') ?: 'novel_password';

// Initialize database connection
try {
    $dsn = "mysql:host=$dbHost;port=$dbPort;dbname=$dbName;charset=utf8mb4";
    $pdo = new PDO($dsn, $dbUser, $dbPass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database connection failed', 'message' => $e->getMessage()]);
    exit;
}

// Helper function to get request body
function getRequestBody() {
    return json_decode(file_get_contents('php://input'), true) ?: [];
}

// Helper function to get view count for a novel
function getViewCount($pdo, $novelId) {
    $stmt = $pdo->prepare('SELECT COUNT(*) as count FROM novel_views WHERE novel_id = ?');
    $stmt->execute([$novelId]);
    return (int)$stmt->fetch()['count'];
}

// Route: GET / - Health check
if ($uri === '/' && $method === 'GET') {
    echo json_encode([
        'service' => 'Content Service',
        'status' => 'running',
        'database' => 'connected'
    ]);
    exit;
}

// Route: GET /novels - Get all novels
if (preg_match('/^\/novels\/?$/', $uri) && $method === 'GET') {
    try {
        $stmt = $pdo->query('
            SELECT n.*, 
                   COUNT(DISTINCT nv.id) as view_count
            FROM novels n
            LEFT JOIN novel_views nv ON n.id = nv.novel_id
            GROUP BY n.id
            ORDER BY n.created_at DESC
        ');
        $novels = $stmt->fetchAll();
        
        // Convert view_count to integer
        foreach ($novels as &$novel) {
            $novel['view_count'] = (int)$novel['view_count'];
        }
        
        echo json_encode($novels);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to fetch novels', 'message' => $e->getMessage()]);
    }
    exit;
}

// Route: GET /novels/{id} - Get single novel
if (preg_match('/^\/novels\/(\d+)\/?$/', $uri, $matches) && $method === 'GET') {
    try {
        $novelId = $matches[1];
        $stmt = $pdo->prepare('SELECT * FROM novels WHERE id = ?');
        $stmt->execute([$novelId]);
        $novel = $stmt->fetch();
        
        if (!$novel) {
            http_response_code(404);
            echo json_encode(['error' => 'Novel not found']);
            exit;
        }
        
        // Add view count
        $novel['view_count'] = getViewCount($pdo, $novelId);
        
        echo json_encode($novel);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to fetch novel', 'message' => $e->getMessage()]);
    }
    exit;
}

// Route: POST /novels - Create new novel (Admin)
if (preg_match('/^\/novels\/?$/', $uri) && $method === 'POST') {
    try {
        $data = getRequestBody();
        
        if (!isset($data['title']) || !isset($data['author']) || !isset($data['publisher']) || !isset($data['content'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Missing required fields: title, author, publisher, content']);
            exit;
        }
        
        $stmt = $pdo->prepare('
            INSERT INTO novels (title, author, publisher, content, description, cover, published_date)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        ');
        
        $stmt->execute([
            $data['title'],
            $data['author'],
            $data['publisher'],
            $data['content'],
            $data['description'] ?? null,
            $data['cover'] ?? 'https://via.placeholder.com/300x400',
            $data['published_date'] ?? null
        ]);
        
        $novelId = $pdo->lastInsertId();
        
        // Fetch the created novel
        $stmt = $pdo->prepare('SELECT * FROM novels WHERE id = ?');
        $stmt->execute([$novelId]);
        $novel = $stmt->fetch();
        $novel['view_count'] = 0;
        
        http_response_code(201);
        echo json_encode([
            'message' => 'Novel created successfully',
            'novel' => $novel
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to create novel', 'message' => $e->getMessage()]);
    }
    exit;
}

// Route: PUT /novels/{id} - Update novel (Admin)
if (preg_match('/^\/novels\/(\d+)\/?$/', $uri, $matches) && $method === 'PUT') {
    try {
        $novelId = $matches[1];
        $data = getRequestBody();
        
        // Check if novel exists
        $stmt = $pdo->prepare('SELECT id FROM novels WHERE id = ?');
        $stmt->execute([$novelId]);
        if (!$stmt->fetch()) {
            http_response_code(404);
            echo json_encode(['error' => 'Novel not found']);
            exit;
        }
        
        // Build dynamic update query
        $updateFields = [];
        $values = [];
        
        if (isset($data['title'])) {
            $updateFields[] = 'title = ?';
            $values[] = $data['title'];
        }
        if (isset($data['author'])) {
            $updateFields[] = 'author = ?';
            $values[] = $data['author'];
        }
        if (isset($data['publisher'])) {
            $updateFields[] = 'publisher = ?';
            $values[] = $data['publisher'];
        }
        if (isset($data['content'])) {
            $updateFields[] = 'content = ?';
            $values[] = $data['content'];
        }
        if (isset($data['description'])) {
            $updateFields[] = 'description = ?';
            $values[] = $data['description'];
        }
        if (isset($data['cover'])) {
            $updateFields[] = 'cover = ?';
            $values[] = $data['cover'];
        }
        if (isset($data['published_date'])) {
            $updateFields[] = 'published_date = ?';
            $values[] = $data['published_date'];
        }
        
        if (empty($updateFields)) {
            http_response_code(400);
            echo json_encode(['error' => 'No fields to update']);
            exit;
        }
        
        $values[] = $novelId;
        $sql = 'UPDATE novels SET ' . implode(', ', $updateFields) . ' WHERE id = ?';
        $stmt = $pdo->prepare($sql);
        $stmt->execute($values);
        
        // Fetch updated novel
        $stmt = $pdo->prepare('SELECT * FROM novels WHERE id = ?');
        $stmt->execute([$novelId]);
        $novel = $stmt->fetch();
        $novel['view_count'] = getViewCount($pdo, $novelId);
        
        echo json_encode([
            'message' => 'Novel updated successfully',
            'novel' => $novel
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to update novel', 'message' => $e->getMessage()]);
    }
    exit;
}

// Route: DELETE /novels/{id} - Delete novel (Admin)
if (preg_match('/^\/novels\/(\d+)\/?$/', $uri, $matches) && $method === 'DELETE') {
    try {
        $novelId = $matches[1];
        
        $stmt = $pdo->prepare('DELETE FROM novels WHERE id = ?');
        $stmt->execute([$novelId]);
        
        if ($stmt->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(['error' => 'Novel not found']);
            exit;
        }
        
        echo json_encode(['message' => 'Novel deleted successfully']);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to delete novel', 'message' => $e->getMessage()]);
    }
    exit;
}

// Route: POST /novels/{id}/view - Increment view count
if (preg_match('/^\/novels\/(\d+)\/view\/?$/', $uri, $matches) && $method === 'POST') {
    try {
        $novelId = $matches[1];
        $data = getRequestBody();
        $userId = $data['user_id'] ?? null;
        
        // Check if novel exists
        $stmt = $pdo->prepare('SELECT id FROM novels WHERE id = ?');
        $stmt->execute([$novelId]);
        if (!$stmt->fetch()) {
            http_response_code(404);
            echo json_encode(['error' => 'Novel not found']);
            exit;
        }
        
        // Add view record
        $stmt = $pdo->prepare('INSERT INTO novel_views (novel_id, user_id) VALUES (?, ?)');
        $stmt->execute([$novelId, $userId]);
        
        $viewCount = getViewCount($pdo, $novelId);
        
        echo json_encode([
            'message' => 'View recorded',
            'view_count' => $viewCount
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Failed to record view', 'message' => $e->getMessage()]);
    }
    exit;
}

// 404 Not Found
http_response_code(404);
echo json_encode(['error' => 'Not Found', 'uri' => $uri, 'method' => $method]);
