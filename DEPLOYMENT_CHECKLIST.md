# ✅ DEPLOYMENT CHECKLIST - Novel-Go Platform

Checklist lengkap untuk memastikan semua setup sudah benar.

---

## 🔧 PRE-DEPLOYMENT

### System Requirements
- [ ] Windows 10/11 atau Linux
- [ ] Node.js 16+ installed
- [ ] Python 3.8+ installed
- [ ] PHP 8.0+ installed
- [ ] Composer installed
- [ ] MySQL 8.0+ running
- [ ] Flutter SDK installed
- [ ] Git installed
- [ ] Both devices on same network (WiFi/LAN)

### Network Requirements
- [ ] Device A & B can ping each other
- [ ] Port 3001, 3002, 5003, 8080 available
- [ ] Firewall allows these ports
- [ ] No VPN/Proxy blocking local IPs

---

## 📍 DEVICE A SETUP (Backend Services)

### Environment Setup
- [ ] MySQL Server running on port 3306
- [ ] `.env` file created for auth-service
- [ ] `.env` file created for collection-service
- [ ] `.env` file created for novel_core (Laravel)
- [ ] All `.env` have correct DB credentials

### Auth Service (Node.js - Port 3001)
- [ ] Folder: `auth-service/` exists
- [ ] `npm install` completed
- [ ] `.env` file configured
- [ ] `npm start` running in Terminal 1
- [ ] Status: Listening on port 3001
- [ ] Health check: `curl http://localhost:3001/` returns 200

### Laravel Content Service (PHP - Port 8080)
- [ ] Folder: `novel_core/` exists
- [ ] `composer install` completed
- [ ] `.env` file configured
- [ ] Database migrations completed
- [ ] `php artisan serve` running in Terminal 2 on port 8080
- [ ] Health check: `curl http://localhost:8080/novels` returns 200
- [ ] Sample data exists (at least 2 novels)

### Collection Service (Node.js - Port 3002)
- [ ] Folder: `collection-service/` exists
- [ ] `npm install` completed
- [ ] `.env` file configured
- [ ] `npm start` running in Terminal 3
- [ ] Status: Listening on port 3002
- [ ] Health check: `curl http://localhost:3002/` returns 200

### Device A Verification
- [ ] `ipconfig` output saved (IP: `192.168.1.13` atau berbeda)
- [ ] All 3 services running simultaneously
- [ ] Can access from Device A:
  - [ ] http://localhost:3001/ → 200 OK
  - [ ] http://localhost:8080/novels → 200 OK
  - [ ] http://localhost:3002/ → 200 OK

---

## 📱 DEVICE B SETUP (Social Service + Flutter)

### Python Social Service (Port 5003)
- [ ] Folder: `social_service/` exists
- [ ] `pip install -r requirements.txt` completed
- [ ] `python app.py` running in Terminal 1
- [ ] Status: Listening on 0.0.0.0:5003
- [ ] Health check: `curl http://192.168.1.9:5003/` returns 200
- [ ] Contains test data (comments)

### Flutter App Configuration
- [ ] File: `flutter/novel_flutter/lib/config.dart` exists
- [ ] IP Device A: `192.168.1.13` (atau sesuai `ipconfig`)
- [ ] IP Device B: `192.168.1.9` (atau sesuai `ipconfig`)
- [ ] Config updated:
  ```dart
  static const String authCollectionIp = '192.168.1.13';
  static const String contentIp = '192.168.1.13';
  static const String interactionIp = '192.168.1.9';
  ```

### Flutter Build & Run
- [ ] `flutter clean` executed
- [ ] `flutter pub get` completed
- [ ] `flutter run` executed and app loaded
- [ ] No compile errors
- [ ] App opens and shows initial screen

### Device B Verification
- [ ] Can access from Device B:
  - [ ] http://192.168.1.13:3001/ → 200 OK
  - [ ] http://192.168.1.13:8080/novels → 200 OK
  - [ ] http://192.168.1.13:3002/ → 200 OK
  - [ ] http://192.168.1.9:5003/ → 200 OK
- [ ] `ipconfig` output saved (IP: `192.168.1.9` atau berbeda)

---

## 📊 INTEGRATION TEST

### User Registration & Login
- [ ] Open Flutter app on Device B
- [ ] Register new user with email `testuser@test.com`
- [ ] Confirmation: Account created successfully
- [ ] Login with new credentials
- [ ] Confirmation: JWT token received

### Browse Content
- [ ] After login, browse novels list
- [ ] Confirmation: At least 2 novels visible
- [ ] Tap on a novel to see details
- [ ] Confirmation: Novel data + chapters loaded from Laravel

### Read Chapters
- [ ] Click on any chapter
- [ ] Confirmation: Chapter content displayed
- [ ] Swipe or navigate to next chapter
- [ ] Confirmation: Navigation works smoothly

### Post Comments
- [ ] In chapter view, scroll to comments section
- [ ] Confirmation: Existing comments visible
- [ ] Tap "Add Comment" button
- [ ] Type comment text
- [ ] Tap "Post" button
- [ ] Confirmation: Comment appears in list
- [ ] Check backend: `curl http://192.168.1.9:5003/comments`
- [ ] Confirmation: New comment in database

### Edit/Delete Comments
- [ ] Find your comment in the list
- [ ] Tap edit button
- [ ] Modify comment text
- [ ] Tap save
- [ ] Confirmation: Comment updated
- [ ] Tap delete button
- [ ] Confirmation: Comment removed from list

### Collections (Favorites)
- [ ] In novel detail view, tap heart/favorite button
- [ ] Confirmation: Novel added to collection
- [ ] Open Collections menu
- [ ] Confirmation: Added novel appears in list

---

## 🔴 ERROR RESOLUTION

### If Any Service Won't Start

#### Auth Service (Port 3001)
- [ ] Check: DB connection in `.env`
- [ ] Check: MySQL server running (`mysql -u novel_user -p`)
- [ ] Check: npm modules installed (`npm install`)
- [ ] Try: `npm start` with verbose logging

#### Laravel Service (Port 8080)
- [ ] Check: `.env` database configuration
- [ ] Check: Migrations ran (`php artisan migrate`)
- [ ] Check: Composer dependencies installed
- [ ] Try: `php artisan serve --host=0.0.0.0 --port=8080`

#### Python Service (Port 5003)
- [ ] Check: Flask installed (`pip list | grep Flask`)
- [ ] Check: No other process on port 5003
- [ ] Try: `python app.py` with debug output
- [ ] Check: `requirements.txt` has all dependencies

#### Flutter App
- [ ] Check: `config.dart` has correct IPs
- [ ] Check: Device B can reach Device A (ping)
- [ ] Check: All backend services running
- [ ] Try: `flutter clean` and `flutter pub get` again

---

## 📈 PERFORMANCE TEST

### Load Testing (Optional)
- [ ] Try fetching 100+ comments
- [ ] Try browsing multiple novels quickly
- [ ] Try opening chapters repeatedly
- [ ] Confirmation: No crashes or timeouts

### API Response Time (Optional)
- [ ] Measure: GET /novels (target: <500ms)
- [ ] Measure: GET /comments (target: <500ms)
- [ ] Measure: POST /comments (target: <1000ms)
- [ ] Measure: Login endpoint (target: <1000ms)

---

## 📝 DOCUMENTATION

- [ ] `SETUP_DEVICE_A.md` reviewed
- [ ] `SETUP_DEVICE_B.md` reviewed
- [ ] `QUICK_START.md` reviewed
- [ ] All environment variables documented
- [ ] All IPs documented
- [ ] Troubleshooting steps noted

---

## 🎯 FINAL VERIFICATION

**Device A Status:**
```
✅ Terminal 1: Auth Service (3001) RUNNING
✅ Terminal 2: Laravel Service (8080) RUNNING
✅ Terminal 3: Collection Service (3002) RUNNING
✅ IP Address: 192.168.1.13 (Confirmed)
```

**Device B Status:**
```
✅ Terminal 1: Python Social Service (5003) RUNNING
✅ Terminal 2: Flutter App (Connected & Loaded)
✅ IP Address: 192.168.1.9 (Confirmed)
```

**Integration Status:**
```
✅ Device B can reach Device A on all ports
✅ All 4 backend services accessible
✅ Flutter app connects to all services
✅ User registration working
✅ User login working
✅ Content browsing working
✅ Comment posting working
✅ All features functional
```

---

## 🚀 GO LIVE CONFIRMATION

When all checkboxes are ticked:
- [ ] All 5 processes running stably for 30+ minutes
- [ ] No connection drops
- [ ] No error messages in logs
- [ ] All test scenarios passed
- [ ] Ready for production/demo

**Status: ✅ READY FOR PRODUCTION**

---

## 📞 SUPPORT

If anything is unchecked:
1. Go back to `SETUP_DEVICE_A.md` or `SETUP_DEVICE_B.md`
2. Follow the Troubleshooting section
3. Check terminal logs for error details
4. Restart the problematic service

Good luck! 🎉
