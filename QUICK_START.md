c# ⚡ QUICK START GUIDE - SETUP 2 DEVICE

Ringkasan cepat setup Device A & Device B dalam satu file.

---

## 📍 SETUP OVERVIEW

```
DEVICE A (IP: 192.168.1.13)
├── Auth Service ...................... Port 3001 (Node.js)
├── Laravel Content Service ........... Port 8080 (PHP)
└── Collection Service ............... Port 3002 (Node.js)

DEVICE B (IP: 192.168.1.9)
├── Python Social Service ............ Port 5003 (Python)
└── Flutter App ...................... (Connect ke semua service Device A)
```

---

## 🚀 QUICK START DEVICE A

**Terminal 1 (Auth Service):**
```bash
cd auth-service
npm install
npm start
# Expected: Auth Service running on port 3001
```

**Terminal 2 (Laravel Content):**
```bash
cd novel_core
composer install
php artisan serve --host=0.0.0.0 --port=8080
# Expected: Laravel development server started on 0.0.0.0:8080
```

**Terminal 3 (Collection Service):**
```bash
cd collection-service
npm install
npm start
# Expected: Collection Service running on port 3002
```

---

## 🚀 QUICK START DEVICE B

**Terminal 1 (Python Social Service):**
```bash
cd social_service
pip install -r requirements.txt
python app.py
# Expected: Running on http://0.0.0.0:5003
```

**Terminal 2 (Flutter):**
```bash
cd flutter/novel_flutter

# Update IP di lib/config.dart dulu! (lihat: SETUP_DEVICE_B.md)

flutter clean
flutter pub get
flutter run
```

---

## 🔧 KONFIGURASI IP (PALING PENTING!)

### Step 1: Cek IP Device A
```bash
# Di Device A
ipconfig
# Catat: IPv4 Address = 192.168.1.13
```

### Step 2: Cek IP Device B
```bash
# Di Device B
ipconfig
# Catat: IPv4 Address = 192.168.1.9
```

### Step 3: Update Config Flutter

Edit `flutter/novel_flutter/lib/config.dart`:

```dart
class Config {
  static const String authCollectionIp = '192.168.1.13';  // ← IP Device A
  static const String contentIp = '192.168.1.13';         // ← IP Device A
  static const String interactionIp = '192.168.1.9';      // ← IP Device B
  
  static const String baseUrlAuth = 'http://$authCollectionIp:3001';
  static const String baseUrlNovel = 'http://$contentIp:8080';
  static const String baseUrlInteraction = 'http://$interactionIp:5003';
  static const String baseUrlCollection = 'http://$authCollectionIp:3002';
}
```

---

## ✅ TESTING ENDPOINTS

Jalankan dari Device B:

```powershell
# Auth Service
curl http://192.168.1.13:3001/

# Laravel Service
curl http://192.168.1.13:8080/novels

# Collection Service
curl http://192.168.1.13:3002/

# Python Social Service
curl http://192.168.1.9:5003/
```

Semua harus return **Status 200**.

---

## 📱 TEST FLUTTER APP

1. **Register** → Auth Service
2. **Login** → Auth Service
3. **Browse Novels** → Laravel Service
4. **Read Chapters** → Laravel Service
5. **Post Comments** → Python Social Service
6. **Manage Collections** → Collection Service

---

## 🔴 COMMON ISSUES & FIXES

| Issue | Fix |
|-------|-----|
| "Cannot connect to DB" | Pastikan MySQL running, cek `.env` credentials |
| "Port already in use" | `netstat -ano \| findstr :3001` lalu `taskkill /PID xxx /F` |
| "Module not found (Node)" | `npm install` di folder service |
| "Package not found (PHP)" | `composer install` di folder novel_core |
| "Flask not found" | `pip install -r requirements.txt` di social_service |
| "IP tidak bisa diakses" | Cek firewall, pastikan same network, restart service |
| "Flutter tidak terkoneksi" | Hot restart Flutter (tekan `R`), cek config.dart IP |

---

## 📁 FOLDER STRUCTURE

```
Novel-go - Copy/
├── auth-service/           ← Device A (npm start)
├── novel_core/             ← Device A (php artisan serve)
├── collection-service/     ← Device A (npm start)
├── social_service/         ← Device B (python app.py)
├── flutter/
│   └── novel_flutter/
│       └── lib/
│           └── config.dart ← EDIT INI (IP ADDRESS)
├── SETUP_DEVICE_A.md       ← Panduan lengkap Device A
└── SETUP_DEVICE_B.md       ← Panduan lengkap Device B
```

---

## 💾 ENVIRONMENT FILES

### auth-service/.env
```env
PORT=3001
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=novel_db
DB_USER=novel_user
DB_PASSWORD=novel_password
JWT_SECRET=your_jwt_secret_key_here
```

### collection-service/.env
```env
PORT=3002
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=novel_db
DB_USER=novel_user
DB_PASSWORD=novel_password
JWT_SECRET=your_jwt_secret_key_here
```

### novel_core/.env
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=novel_db
DB_USERNAME=novel_user
DB_PASSWORD=novel_password
```

---

## 📊 VERIFICATION CHECKLIST

### Device A
- [ ] Port 3001 running (Auth Service)
- [ ] Port 8080 running (Laravel Service)
- [ ] Port 3002 running (Collection Service)
- [ ] IP dicatat (untuk Device B config)

### Device B
- [ ] Port 5003 running (Python Social Service)
- [ ] config.dart sudah update dengan IP yang benar
- [ ] Flutter app dapat connect ke semua service
- [ ] Semua fitur berfungsi (register, login, browse, comment)

---

## 🆘 NEED HELP?

1. **Lihat log terminal** untuk error message yang detail
2. **Cek Troubleshooting section** di `SETUP_DEVICE_A.md` atau `SETUP_DEVICE_B.md`
3. **Test individual endpoint** dengan curl sebelum test di Flutter
4. **Restart service** jika ada perubahan config

---

## 📚 FULL DOCUMENTATION

- **Device A Setup:** `SETUP_DEVICE_A.md` (lengkap + troubleshooting)
- **Device B Setup:** `SETUP_DEVICE_B.md` (lengkap + troubleshooting)
- **Test Results:** Lihat terminal output untuk verifikasi

---

## ✨ SUMMARY

**Total 3 Terminal Device A + 2 Terminal Device B = 5 Terminal Running**

```
[Terminal 1] Auth Service (3001) ✅
[Terminal 2] Laravel Service (8080) ✅
[Terminal 3] Collection Service (3002) ✅
[Terminal 4 - Device B] Python Social (5003) ✅
[Terminal 5 - Device B] Flutter App 📱 ✅
```

Semua berjalan bersamaan dan siap untuk testing! 🚀
