# 📚 DOKUMENTASI COMPLETE - Novel-Go Setup Guide

File dokumentasi lengkap untuk setup, testing, dan deployment Novel-Go platform dengan 2 device.

---

## 📖 DAFTAR DOKUMENTASI

### 1. **QUICK_START.md** (Mulai dari sini!)
   - Ringkasan setup 2 device
   - Common issues & fixes
   - Konfigurasi IP (paling penting!)
   - Testing checklist
   - **Waktu**: 5-10 menit baca

### 2. **SETUP_DEVICE_A.md** (Backend Services)
   - Setup Auth Service (Node.js - Port 3001)
   - Setup Laravel Content Service (PHP - Port 8080)
   - Setup Collection Service (Node.js - Port 3002)
   - Testing endpoints
   - Troubleshooting lengkap
   - **Waktu**: 30-45 menit setup

### 3. **SETUP_DEVICE_B.md** (Interaction + Flutter)
   - Setup Python Social Service (Port 5003)
   - Setup Flutter App
   - Konfigurasi IP untuk komunikasi inter-device
   - Testing integration
   - Troubleshooting lengkap
   - **Waktu**: 20-30 menit setup

### 4. **DEPLOYMENT_CHECKLIST.md** (Verifikasi)
   - Pre-deployment checklist
   - Setup verification di Device A & B
   - Integration testing
   - Error resolution
   - Performance testing (optional)
   - **Waktu**: 15-20 menit verification

---

## 🎯 QUICKEST PATH (Jika Sudah Pernah Setup)

1. Baca: **QUICK_START.md** (5 min)
2. Setup Device A services (15 min)
3. Setup Device B services (10 min)
4. Update config.dart dengan IP (2 min)
5. Run & test (5 min)
6. Total: ~40 menit

---

## 🔄 SETUP WORKFLOW

```
Step 1: Read QUICK_START.md
   ↓
Step 2: Setup Device A (3 terminals)
   ├── Auth Service (3001)
   ├── Laravel Service (8080)
   └── Collection Service (3002)
   ↓
Step 3: Setup Device B (2 terminals)
   ├── Python Social Service (5003)
   └── Flutter App
   ↓
Step 4: Configure IPs in config.dart
   ↓
Step 5: Run Integration Tests
   ↓
Step 6: Use DEPLOYMENT_CHECKLIST.md for verification
   ↓
Step 7: Go Live! ✅
```

---

## 📊 SERVICE ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVICE A (Laptop 1)                      │
│                    IP: 192.168.1.13                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────┐                                      │
│  │  MySQL Database  │                                      │
│  │   Port 3306      │                                      │
│  └────────┬─────────┘                                      │
│           │                                                │
│  ┌────────┴──────────────────────────┐                    │
│  │         ┌──────────────┐          │                    │
│  │         │Auth Service  │  Port    │                    │
│  │         │ Node.js      │  3001    │                    │
│  │         └──────────────┘          │                    │
│  │                                  │                    │
│  │         ┌──────────────┐          │                    │
│  │         │Laravel Service          │                    │
│  │         │ PHP/Lumen    │  Port    │                    │
│  │         │              │  8080    │                    │
│  │         └──────────────┘          │                    │
│  │                                  │                    │
│  │         ┌──────────────┐          │                    │
│  │         │Collection    │  Port    │                    │
│  │         │Service Node.js          │                    │
│  │         │              │  3002    │                    │
│  │         └──────────────┘          │                    │
│  └───────────────────────────────────┘                    │
│                                                             │
└────────────────────┬────────────────────────────────────────┘
                     │ Network Communication
                     │
┌────────────────────▼────────────────────────────────────────┐
│                    DEVICE B (Laptop 2)                      │
│                    IP: 192.168.1.9                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────┐                             │
│  │  Python Social Service   │                             │
│  │  Flask - Port 5003       │                             │
│  │  (Comments & Feedback)   │                             │
│  └──────────────────────────┘                             │
│                                                             │
│  ┌──────────────────────────┐                             │
│  │    Flutter Mobile App    │                             │
│  │   (Connects to all       │                             │
│  │    services on Device A) │                             │
│  └──────────────────────────┘                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 ENVIRONMENT VARIABLES

### Device A - auth-service/.env
```env
PORT=3001
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=novel_db
DB_USER=novel_user
DB_PASSWORD=novel_password
JWT_SECRET=your_jwt_secret
NODE_ENV=development
```

### Device A - collection-service/.env
```env
PORT=3002
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=novel_db
DB_USER=novel_user
DB_PASSWORD=novel_password
JWT_SECRET=your_jwt_secret
NODE_ENV=development
```

### Device A - novel_core/.env
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=novel_db
DB_USERNAME=novel_user
DB_PASSWORD=novel_password
```

### Device B - flutter/novel_flutter/lib/config.dart
```dart
class Config {
  static const String authCollectionIp = '192.168.1.13';  // Device A IP
  static const String contentIp = '192.168.1.13';         // Device A IP
  static const String interactionIp = '192.168.1.9';      // Device B IP
  
  static const String baseUrlAuth = 'http://$authCollectionIp:3001';
  static const String baseUrlNovel = 'http://$contentIp:8080';
  static const String baseUrlInteraction = 'http://$interactionIp:5003';
  static const String baseUrlCollection = 'http://$authCollectionIp:3002';
}
```

---

## 🚀 BASIC COMMANDS

### Device A - Terminal 1 (Auth Service)
```bash
cd auth-service
npm install
npm start
```

### Device A - Terminal 2 (Laravel Service)
```bash
cd novel_core
composer install
php artisan serve --host=0.0.0.0 --port=8080
```

### Device A - Terminal 3 (Collection Service)
```bash
cd collection-service
npm install
npm start
```

### Device B - Terminal 1 (Python Service)
```bash
cd social_service
pip install -r requirements.txt
python app.py
```

### Device B - Terminal 2 (Flutter)
```bash
cd flutter/novel_flutter
flutter clean
flutter pub get
flutter run
```

---

## ✅ TESTING COMMANDS

### Test dari Device B

```powershell
# Test Auth Service
curl http://192.168.1.13:3001/

# Test Laravel Service
curl http://192.168.1.13:8080/novels

# Test Collection Service
curl http://192.168.1.13:3002/

# Test Python Social Service
curl http://192.168.1.9:5003/

# Register new user
$json = @{name="Test";email="test@test.com";password="pass"} | ConvertTo-Json
curl -X POST http://192.168.1.13:3001/auth/register `
  -ContentType "application/json" -Body $json

# Login
$json = @{email="test@test.com";password="pass"} | ConvertTo-Json
curl -X POST http://192.168.1.13:3001/auth/login `
  -ContentType "application/json" -Body $json
```

---

## 🆘 QUICK TROUBLESHOOTING

| Masalah | Solusi |
|---------|--------|
| "Cannot connect to DB" | Cek MySQL running, cek `.env` credentials |
| "Port already in use" | Cek process: `netstat -ano \| findstr :PORT`, kill: `taskkill /PID xxx /F` |
| "npm install error" | `npm cache clean --force`, hapus `node_modules`, `npm install` lagi |
| "Composer error" | `composer install` dengan internet connection |
| "Flutter can't connect" | Cek config.dart IP, restart app (tekan R), cek firewall |
| "Device B can't reach Device A" | Ping: `ping 192.168.1.13`, same network?, firewall? |

---

## 📞 WHEN TO USE WHICH DOCUMENTATION

| Situasi | Gunakan |
|---------|---------|
| First time setup | QUICK_START.md → SETUP_DEVICE_A.md → SETUP_DEVICE_B.md |
| Repeat setup | QUICK_START.md → Copy commands |
| Troubleshooting | SETUP_DEVICE_A/B.md Troubleshooting section |
| Final verification | DEPLOYMENT_CHECKLIST.md |
| Understanding architecture | This file (README.md) |

---

## 🎓 LEARNING PATH

1. **Understand** - Baca architecture di file ini
2. **Quick Start** - Baca QUICK_START.md
3. **Setup Device A** - Follow SETUP_DEVICE_A.md step-by-step
4. **Setup Device B** - Follow SETUP_DEVICE_B.md step-by-step
5. **Verify** - Use DEPLOYMENT_CHECKLIST.md
6. **Test** - Run all tests dan verify output
7. **Go Live** - Mark all checklist items

---

## 📝 IMPORTANT NOTES

1. **IP Addresses are crucial** - Setiap device punya IP unik, HARUS sesuai di config
2. **5 terminals running** - 3 di Device A, 2 di Device B
3. **Database must be running** - MySQL server harus jalan untuk ketiga service Device A
4. **Same network** - Kedua laptop harus di network yang sama
5. **Firewall** - Buka ports 3001, 3002, 5003, 8080 di firewall Windows

---

## ✨ SUMMARY

**Files ini menyediakan:**
- ✅ Complete step-by-step setup guide
- ✅ IP configuration examples
- ✅ Testing procedures
- ✅ Troubleshooting solutions
- ✅ Deployment verification
- ✅ Quick reference commands

**Total Setup Time:**
- ⏱️ First time: ~2 hours
- ⏱️ Repeat setup: ~45 minutes
- ⏱️ With documentation: Always reference docs!

---

**Version**: 1.0  
**Last Updated**: January 15, 2026  
**Status**: Production Ready ✅

For questions, refer to the specific guide document or troubleshooting section.

Good luck! 🚀
