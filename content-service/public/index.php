<?php
// Minimal router for prototype without full vendor
// In a real Lumen app, this would bootstrap the framework.

$uri = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// Simple Router
if ($uri == '/' && $method == 'GET') {
    echo json_encode(['message' => 'Content Service (Lumen) is running']);
    exit;
}

// Mock Data
$novels = [
    ['id' => 1, 'title' => 'The Beginning After The End', 'author' => 'TurtleMe', 'cover' => 'https://via.placeholder.com/150'],
    ['id' => 2, 'title' => 'Solo Leveling', 'author' => 'Chugong', 'cover' => 'https://via.placeholder.com/150']
];

// GET /novels
if (strpos($uri, '/novels') === 0 && $method == 'GET') {
    if (preg_match('/^\/novels\/(\d+)$/', $uri, $matches)) {
        $id = $matches[1];
        echo json_encode(['id' => $id, 'title' => "Novel $id", 'content' => "Chapter content for Novel $id..."]);
    } else {
        echo json_encode($novels);
    }
    exit;
}

http_response_code(404);
echo json_encode(['error' => 'Not Found']);
