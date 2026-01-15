# 🖥️ SETUP DENGAN 3 DEVICE - Scalable Architecture

Dokumentasi untuk setup Novel-Go dengan **3 device** (scalable dari 2 device).

---

## 📍 ARCHITECTURE 3 DEVICE

```
┌─────────────────────────────────────────────┐
│  DEVICE A (Backend Core)                    │
│  IP: 192.168.1.10                          │
├─────────────────────────────────────────────┤
│  ✅ Auth Service ........... Port 3001      │
│  ✅ Collection Service ..... Port 3002      │
│  ✅ MySQL Database ......... Port 3306      │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│  DEVICE B (Content Service)                 │
│  IP: 192.168.1.11                          │
├─────────────────────────────────────────────┤
│  ✅ Laravel Content Service  Port 8080      │
│  ✅ Database connection to Device A         │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│  DEVICE C (Social + Flutter)                │
│  IP: 192.168.1.12                          │
├─────────────────────────────────────────────┤
│  ✅ Python Social Service .. Port 5003      │
│  ✅ Flutter App                             │
└─────────────────────────────────────────────┘
```

---

## 🔄 COMPARISON: 2 Device vs 3 Device

### 2 Device Setup (Current)
```
Device A (192.168.1.13):
  ├── Auth Service (3001)
  ├── Laravel Content (8080)
  └── Collection Service (3002)

Device B (192.168.1.9):
  ├── Python Social Service (5003)
  └── Flutter App
```

### 3 Device Setup (New)
```
Device A (192.168.1.10):
  ├── Auth Service (3001)
  ├── Collection Service (3002)
  └── MySQL Database (3306)

Device B (192.168.1.11):
  └── Laravel Content Service (8080)
       └── Connect to Device A MySQL

Device C (192.168.1.12):
  ├── Python Social Service (5003)
  └── Flutter App
```

---

## ✨ KEUNTUNGAN 3 DEVICE SETUP

| Aspek | 2 Device | 3 Device |
|-------|----------|----------|
| **Load Distribution** | Content + Auth sama device | Content separate (better) |
| **Scalability** | Limited | Better (easy add more devices) |
| **Development** | Shared resource | Independent teams |
| **Maintenance** | One device = whole system down | Fault isolation |
| **Testing** | Simultaneous | Independent testing |

---

## 🚀 LANGKAH SETUP 3 DEVICE

### DEVICE A (192.168.1.10) - Backend Core

**Terminal 1: Auth Service**
```bash
cd auth-service
npm install
# Edit .env dengan:
# DB_HOST=localhost (atau 192.168.1.10)
# DB_PORT=3306
npm start
```

**Terminal 2: Collection Service**
```bash
cd collection-service
npm install
# Edit .env dengan:
# DB_HOST=localhost (atau 192.168.1.10)
npm start
```

**MySQL harus running di Device A:**
```bash
# Windows
net start MySQL80

# Linux
sudo systemctl start mysql

# Verify
mysql -u novel_user -p
# Password: novel_password
```

---

### DEVICE B (192.168.1.11) - Content Service

**Terminal 1: Laravel Content**
```bash
cd novel_core
composer install

# Edit .env dengan:
# DB_CONNECTION=mysql
# DB_HOST=192.168.1.10    (← IP Device A!)
# DB_PORT=3306
# DB_DATABASE=novel_db
# DB_USERNAME=novel_user
# DB_PASSWORD=novel_password

# Jalankan migration ke Database Device A
php artisan migrate

# Jalankan service
php artisan serve --host=0.0.0.0 --port=8080
```

✅ **Laravel sekarang terhubung ke MySQL di Device A!**

---

### DEVICE C (192.168.1.12) - Social + Flutter

**Terminal 1: Python Social Service**
```bash
cd social_service
pip install -r requirements.txt
python app.py
# Running on 0.0.0.0:5003
```

**Terminal 2: Flutter App**
```bash
cd flutter/novel_flutter

# Edit lib/config.dart dengan:
class Config {
  static const String authCollectionIp = '192.168.1.10';  // Device A
  static const String contentIp = '192.168.1.11';         // Device B
  static const String interactionIp = '192.168.1.12';     // Device C (SEKARANG)
  
  static const String baseUrlAuth = 'http://$authCollectionIp:3001';
  static const String baseUrlNovel = 'http://$contentIp:8080';
  static const String baseUrlInteraction = 'http://$interactionIp:5003';
  static const String baseUrlCollection = 'http://$authCollectionIp:3002';
}

flutter clean
flutter pub get
flutter run
```

---

## 🔧 IP CONFIGURATION UNTUK 3 DEVICE

### Dapatkan IP setiap device:

**Device A:**
```bash
ipconfig
# IPv4 Address: 192.168.1.10
```

**Device B:**
```bash
ipconfig
# IPv4 Address: 192.168.1.11
```

**Device C:**
```bash
ipconfig
# IPv4 Address: 192.168.1.12
```

### Update di 3 tempat:

**1. Device A - auth-service/.env & collection-service/.env:**
```env
DB_HOST=192.168.1.10  (atau localhost jika di Device A)
```

**2. Device B - novel_core/.env:**
```env
DB_HOST=192.168.1.10  (← PENTING: IP Device A!)
```

**3. Device C - lib/config.dart:**
```dart
static const String authCollectionIp = '192.168.1.10';    // Device A
static const String contentIp = '192.168.1.11';           // Device B
static const String interactionIp = '192.168.1.12';       // Device C
```

---

## 📊 NETWORK DIAGRAM 3 DEVICE

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           Network (WiFi/LAN)                             │
└──────┬──────────────────────┬──────────────────────┬─────────────────────┘
       │                      │                      │
       │                      │                      │
   ┌───▼────────┐      ┌──────▼──────┐       ┌──────▼──────┐
   │ DEVICE A   │      │ DEVICE B    │       │ DEVICE C    │
   │192.168.1.10│      │192.168.1.11 │       │192.168.1.12 │
   ├────────────┤      ├─────────────┤       ├─────────────┤
   │ ┌────────┐ │      │ ┌─────────┐ │       │ ┌────────┐  │
   │ │ Auth   │ │      │ │ Laravel │ │       │ │ Python │  │
   │ │ 3001   │◄├──┬───┤ │ 8080    │ │       │ │ 5003   │  │
   │ └────────┘ │  │   │ └─────────┘ │       │ └────────┘  │
   │            │  │   │             │       │             │
   │ ┌────────┐ │  │   │ Connects to │       │ ┌────────┐  │
   │ │Collect │ │  │   │ Device A DB │       │ │ Flutter│  │
   │ │ 3002   │ │  │   │             │       │ │ App    │  │
   │ └────────┘ │  │   └─────────────┘       │ └────────┘  │
   │            │  │                         │             │
   │ ┌────────┐ │  │                         │             │
   │ │ MySQL  │◄├──┴─────────────────────────┤             │
   │ │ 3306   │ │                             │             │
   │ └────────┘ │                             │             │
   └────────────┘                             └─────────────┘
```

---

## ✅ TESTING 3 DEVICE

### Step 1: Verify setiap device running

**Device A:**
```powershell
curl http://192.168.1.10:3001/
curl http://192.168.1.10:3002/
```

**Device B:**
```powershell
curl http://192.168.1.11:8080/novels
```

**Device C:**
```powershell
curl http://192.168.1.12:5003/
```

### Step 2: Cross-device testing (dari Device C)

```powershell
# Test auth dari Device A
curl http://192.168.1.10:3001/

# Test content dari Device B
curl http://192.168.1.11:8080/novels

# Test social (local)
curl http://192.168.1.12:5003/

# Test collection dari Device A
curl http://192.168.1.10:3002/
```

Semua harus return **Status 200**.

### Step 3: Flutter integration test

1. Open Flutter app
2. Register user (connect to Device A auth)
3. Login (Device A auth)
4. Browse novels (Device B content)
5. Post comment (Device C social)
6. Manage collection (Device A collection)

---

## 🔴 TROUBLESHOOTING 3 DEVICE

### Device B can't connect to Device A MySQL

**Error:** `SQLSTATE[HY000]: General error: 2006 MySQL server has gone away`

**Solution:**
```bash
# Device A: Check MySQL running
mysql -u novel_user -p

# Device B: Test connection
mysql -h 192.168.1.10 -u novel_user -p
# Password: novel_password

# Device B: Edit .env
DB_HOST=192.168.1.10
DB_CHARSET=utf8mb4
DB_COLLATION=utf8mb4_unicode_ci

# Device B: Retry
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8080
```

### Device C can't reach Device B Laravel

**Error:** `Unable to connect to 192.168.1.11:8080`

**Solution:**
1. Check Device B running: `curl http://localhost:8080/novels` (dari Device B)
2. Check firewall: Buka port 8080 di Device B firewall
3. Check network: `ping 192.168.1.11` dari Device C
4. Check config.dart: `contentIp = '192.168.1.11'`
5. Hot restart Flutter: Tekan `R`

### Migration error di Device B

**Error:** `SQLSTATE[42S02]: Table 'novel_db' not found`

**Solution:**
```bash
# Device A: Create database
mysql -u novel_user -p
mysql> CREATE DATABASE novel_db;
mysql> EXIT;

# Device B: Run migration
php artisan migrate
```

---

## 📋 SETUP CHECKLIST 3 DEVICE

### Device A (Backend)
- [ ] MySQL running on port 3306
- [ ] Auth Service running on port 3001
- [ ] Collection Service running on port 3002
- [ ] IP recorded: 192.168.1.10
- [ ] All services respond to health check

### Device B (Content)
- [ ] Laravel installed and configured
- [ ] `.env` pointing to Device A MySQL (192.168.1.10)
- [ ] Migrations completed
- [ ] Service running on port 8080
- [ ] IP recorded: 192.168.1.11
- [ ] Can connect to Device A MySQL
- [ ] `curl http://localhost:8080/novels` returns data

### Device C (Social + Flutter)
- [ ] Python Social Service running on port 5003
- [ ] `config.dart` with correct IPs:
  - [ ] authCollectionIp = '192.168.1.10' (Device A)
  - [ ] contentIp = '192.168.1.11' (Device B)
  - [ ] interactionIp = '192.168.1.12' (Device C)
- [ ] Flutter app compiled and running
- [ ] Can access all endpoints from Device C

### Network
- [ ] All 3 devices on same WiFi/LAN
- [ ] Device A ↔ Device B ping works
- [ ] Device A ↔ Device C ping works
- [ ] Device B ↔ Device C ping works
- [ ] Firewall allows ports: 3001, 3002, 5003, 8080, 3306

---

## 🎯 ADVANCED: 3 DEVICE + DATABASE BACKUP

Untuk production, backup database di Device A:

```bash
# Device A: Backup database
mysqldump -u novel_user -p novel_db > backup.sql

# Device B: Restore if needed
mysql -h 192.168.1.10 -u novel_user -p novel_db < backup.sql
```

---

## 🚀 SCALING LEBIH JAUH (4+ Device)

Jika butuh lebih dari 3 device:

```
Device A: Database + Auth + Collection
Device B: Laravel Content
Device C: Python Social + Flutter
Device D: Additional services (Caching, Search, etc.)
```

**Prinsip yang sama:**
1. Catat IP setiap device
2. Update configuration dengan IP yang tepat
3. Pastikan database connection ke Device A
4. Test connectivity antar device

---

## 📊 SUMMARY: 2 vs 3 DEVICE

| Komponen | 2 Device | 3 Device |
|----------|----------|----------|
| Backend Core | Device A | Device A |
| Content Service | Device A | Device B |
| Social Service | Device B | Device C |
| Flutter App | Device B | Device C |
| Database | Device A | Device A |
| **Total Services** | 4 | 4 |
| **Total Device** | 2 | 3 |
| **Network Hops** | 1-2 | 1-3 |

---

## ✨ BEST PRACTICES 3 DEVICE

1. **Keep Device A stable** - Database ada di sini
2. **Isolate content service** - Device B fokus on content
3. **Isolate frontend** - Device C fokus on UI + social
4. **Use fixed IPs** - Jika possible, set static IP
5. **Document IPs** - Catat IP setiap device
6. **Monitor connectivity** - Ping antar device regularly
7. **Backup database** - Backup dari Device A regularly

---

## 📝 MIGRATION: 2 DEVICE → 3 DEVICE

Jika sudah setup 2 device dan mau upgrade ke 3:

1. **Setup Device B (baru)** dengan Laravel
2. **Export database** dari Device A
3. **Update Device A MySQL** untuk accept external connections
4. **Import database** ke Device A dari Device B
5. **Update config.dart** dengan Device B IP untuk content
6. **Test** semua endpoints
7. **Done!**

---

## 🎉 CONCLUSION

Setup dengan 3 device:
- ✅ Lebih scalable
- ✅ Better resource distribution
- ✅ Easier maintenance
- ✅ Fault isolation
- ✅ Team-based development

**Prinsip tetap sama:**
1. Catat IP setiap device
2. Update configuration dengan IP yang tepat
3. Test connectivity
4. Done!

---

**Dokumentasi ini scalable untuk 4, 5, atau lebih device dengan prinsip yang sama!**
