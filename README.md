# NOVEL-GO Platform

Welcome to **NOVEL-GO**, a social novel reading platform built with a microservices architecture.

## 🏗 System Architecture

The system mimics a scalable production environment with 4 backend services and a mobile frontend.

| Service | Technology | Port (Host) | Responsibility |
| :--- | :--- | :--- | :--- |
| **Auth Service** | Node.js (Express) | `3001` | User Management (Register, Login) |
| **Content Service** | PHP (Lumen) | `8000` | Novel & Chapter Data |
| **Interaction Service** | Python (Flask) | `5000` | Comments & Reviews |
| **Collection Service** | Node.js (Express) | `3002` | User Library (Bookmarks) |
| **Mobile App** | Flutter | - | User Interface |

---

## 🚀 How to Run

### Prerequisites
- **Docker Desktop** (Installed & Running)
- **Flutter SDK**

### Step 1: Start Backend Services (Docker)
We use Docker Compose to run all 4 backend services simultaneously.

1. Open a terminal in the project root (`Novel-go/`).
2. Run the command:
   ```bash
   docker-compose up --build
   ```
3.  Wait until you see logs indicating all services are running.
    *   *Note: If `interaction-service` fails immediately, ensure port 5000 is free.*

### Step 2: Run Mobile App (Flutter)
1. Open a **new** terminal window.
2. Navigate to the Flutter directory:
   ```bash
   cd flutter/novel_flutter
   ```
3. Run the app (ensure you have an Android Emulator or device connected):
   ```bash
   flutter run
   ```

---

## 🧪 Testing

### Automated Health Check
We have a python script to automatically verify that all 4 microservices are healthy and communicating.
```bash
python tests/test_all_services.py
```

### Manual Testing (Postman)
Refer to **[POSTMAN_GUIDE.md](POSTMAN_GUIDE.md)** for a list of endpoints to test manually (Register, Login, Add Comment, etc.).

---

## 📂 Project Structure
```
Novel-go/
├── auth-service/           # Node.js Auth Service
├── collection-service/     # Node.js Collection Service
├── content-service/        # PHP Content Service
├── interaction-service/    # Python Interaction Service
├── flutter/
│   └── novel_flutter/      # Flutter Mobile App
├── tests/                  # Automated Test Scripts
├── docker-compose.yml      # Docker Orchestration
└── README.md               # This file
```
