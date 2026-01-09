# NOVEL-GO Platform

A social novel reading platform with microservices architecture.

## Architecture

| Service | Technology | Port | Responsibility |
| :--- | :--- | :--- | :--- |
| **Auth Service** | Node.js (Express) | 3001 | User Management (Register, Login) |
| **Content Service** | PHP (Lumen) | 8000 | Novel & Chapter Data |
| **Interaction Service** | Python (Flask) | 5000 | Comments & Reviews |
| **Collection Service** | Node.js (Express) | 3002 | Bookmarks & Library |
| **Mobile App** | Flutter | - | Android/iOS Frontend |

## specific Setup Instructions

### 1. Auth Service & Collection Service (Node.js)
```bash
cd auth-service
npm install
npm start
```
```bash
cd collection-service
npm install
npm start
```

### 2. Interaction Service (Python)
```bash
cd interaction-service
pip install -r requirements.txt
python app.py
```

### 3. Content Service (PHP)
```bash
cd content-service
composer install
php -S localhost:8000 -t public
```

### 4. Mobile App (Flutter)
```bash
cd mobile_app
flutter run
```
