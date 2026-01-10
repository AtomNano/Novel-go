# NOVEL-GO Platform

Welcome to **NOVEL-GO**, a comprehensive novel reading platform built with microservices architecture, MySQL database, and Flutter mobile app.

## 🏗 System Architecture

The platform consists of 4 backend microservices, a MySQL database, phpMyAdmin, and a Flutter mobile application.

| Service | Technology | Port | Responsibility |
| :--- | :--- | :--- | :--- |
| **Auth Service** | Node.js (Express) | `3001` | User Management, Authentication, JWT |
| **Content Service** | PHP | `8000` | Novel CRUD, View Tracking |
| **Interaction Service** | Python (Flask) | `5000` | Comments & Reviews |
| **Collection Service** | Node.js (Express) | `3002` | User Favorites/Bookmarks |
| **MySQL Database** | MySQL 8.0 | `3306` | Data Persistence |
| **phpMyAdmin** | phpMyAdmin | `8081` | Database Management UI |
| **Mobile App** | Flutter | - | User Interface |

---

## 🚀 Quick Start

### Prerequisites
- **Docker Desktop** (Installed & Running)
- **Flutter SDK** (for mobile app)
- **Postman** (optional, for API testing)

### Step 1: Start Backend Services

1. Open terminal in project root (`Novel-go/`)
2. Start all services with Docker Compose:
   ```bash
   docker-compose up --build -d
   ```
3. Wait for all containers to start (check with `docker ps`)

### Step 2: Verify Services

Access the health check endpoints:
- Auth Service: http://localhost:3001/
- Content Service: http://localhost:8000/
- Interaction Service: http://localhost:5000/
- Collection Service: http://localhost:3002/
- phpMyAdmin: http://localhost:8081/ (login: `novel_user` / `novel_password`)

### Step 3: Run Flutter App

1. Navigate to Flutter directory:
   ```bash
   cd flutter/novel_flutter
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app (ensure Android Emulator or device is connected):
   ```bash
   flutter run
   ```

---

## 📊 Database Access

### phpMyAdmin
- URL: http://localhost:8081
- Username: `novel_user`
- Password: `novel_password`
- Database: `novel_db`

### Tables
- `users` - User accounts and profiles
- `novels` - Novel content and metadata
- `comments` - User comments on novels
- `favorites` - User's favorite novels
- `novel_views` - View tracking for statistics

---

## 🧪 Testing

### Automated Health Check
Test all services with Python script:
```bash
python tests/test_all_services.py
```

### Manual Testing with Postman
See **[POSTMAN_GUIDE.md](POSTMAN_GUIDE.md)** for detailed API endpoint documentation.

Quick test endpoints:
- **Register**: `POST http://localhost:3001/auth/register`
- **Login**: `POST http://localhost:3001/auth/login`
- **List Novels**: `GET http://localhost:8000/novels`
- **Get Comments**: `GET http://localhost:5000/comments/novel/1`
- **Get Favorites**: `GET http://localhost:3002/favorites/1`

---

## 👤 Default Users

The database is initialized with sample users:

| Email | Password | Role |
|-------|----------|------|
| admin@novel.com | (use registration) | admin |
| john@example.com | (use registration) | user |
| jane@example.com | (use registration) | user |

**Note**: For security, please register new users through the API endpoints. Sample users have placeholder passwords.

---

## 📱 Flutter App Features

### User Features
- ✅ User Registration & Login
- ✅ Browse novels with view counts
- ✅ Read novel content
- ✅ Add/edit/delete comments
- ✅ Manage favorites
- ✅ User profile management
- ✅ Bottom navigation (Novels, Favorites, Account)

### Admin Features
- ✅ Novel management (CRUD)
- ✅ User management
- ✅ Comment moderation
- ✅ View statistics

---

## 📂 Project Structure

```
Novel-go/
├── auth-service/           # Node.js Auth/User Service
│   ├── Dockerfile
│   ├── package.json
│   └── index.js
├── content-service/        # PHP Content/Novel Service
│   ├── Dockerfile
│   └── public/index.php
├── interaction-service/    # Python Comment Service
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app.py
├── collection-service/     # Node.js Favorites Service
│   ├── Dockerfile
│   ├── package.json
│   └── index.js
├── database/
│   └── init.sql           # Database schema & sample data
├── flutter/
│   └── novel_flutter/     # Flutter Mobile App
│       ├── lib/
│       │   ├── config.dart
│       │   ├── main.dart
│       │   ├── screens/
│       │   └── services/
│       └── pubspec.yaml
├── tests/                 # Automated test scripts
├── docker-compose.yml     # Docker orchestration
├── README.md             # This file
└── POSTMAN_GUIDE.md      # API documentation

```

---

## 🛠 Development

### Stop Services
```bash
docker-compose down
```

### Stop and Remove Volumes (Reset Database)
```bash
docker-compose down -v
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f auth-service
```

### Rebuild After Code Changes
```bash
docker-compose up --build -d
```

---

## 🔧 Troubleshooting

### Port Already in Use
If you get port conflicts, ensure no other services are using ports 3001, 3002, 5000, 8000, 3306, or 8081.

### Database Connection Error
Wait a few seconds after starting containers. MySQL takes time to initialize. Check with:
```bash
docker-compose logs mysql
```

### Flutter Connection Issues
- For Android Emulator: Use `10.0.2.2` instead of `localhost` (already configured)
- For physical device: Change IP addresses in `lib/config.dart` to your computer's local IP

---

## 📖 API Documentation

See [POSTMAN_GUIDE.md](POSTMAN_GUIDE.md) for complete API documentation including:
- Authentication endpoints
- Novel management
- Comment operations
- Favorites management
- Request/response examples

---

## 🤝 Contributing

This is a university project demonstrating microservices architecture, Docker deployment, and Flutter development.

---

## 📝 License

Educational project for UAS (Final Exam) - Semester 5

---

## 🎯 Tech Stack Summary

- **Backend**: Node.js, PHP, Python, Express, Flask
- **Database**: MySQL 8.0
- **Containerization**: Docker, Docker Compose
- **Mobile**: Flutter, Dart
- **Authentication**: JWT (JSON Web Tokens)
- **Security**: Bcrypt password hashing
