# 🖥️ PANDUAN SETUP DEVICE A (Dengan 3 Service)

Dokumentasi lengkap untuk setup **Auth Service**, **Laravel Content Service**, dan **Collection Service** di Device A.

---

## 📋 DAFTAR ISI
1. [Prasyarat](#prasyarat)
2. [Langkah 1: Setup Auth Service](#langkah-1-setup-auth-service)
3. [Langkah 2: Setup Laravel Content Service](#langkah-2-setup-laravel-content-service)
4. [Langkah 3: Setup Collection Service](#langkah-3-setup-collection-service)
5. [Langkah 4: Testing Semua Service](#langkah-4-testing-semua-service)
6. [Troubleshooting](#troubleshooting)

---

## 🔧 PRASYARAT

Pastikan sudah terinstall:
- **Node.js 16+** (cek: `node --version`)
- **NPM 7+** (cek: `npm --version`)
- **PHP 8.0+** (cek: `php --version`)
- **Composer** (cek: `composer --version`)
- **MySQL Server** running (Port 3306)
- **Git**

**Catatan:** Database harus running agar Laravel bisa connect.

---

## LANGKAH 1: SETUP AUTH SERVICE (Node.js - Port 3001)

### 1.1 Clone & Setup Repository

```bash
git clone <repository-url>
cd "Novel-go - Copy"
cd auth-service
```

### 1.2 Install Dependencies

```bash
npm install
```

**Output yang diharapkan:**
```
added XX packages, audited XX packages in XXs
```

### 1.3 Setup Environment Variables

**Buat file `.env` di folder `auth-service`:**

```env
PORT=3001
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=novel_db
DB_USER=novel_user
DB_PASSWORD=novel_password
JWT_SECRET=your_jwt_secret_key_here
NODE_ENV=development
```

**CATATAN:** Sesuaikan dengan config database Anda.

### 1.4 Jalankan Auth Service

**Buka Terminal 1:**

```bash
cd auth-service
npm start
```

**Output yang diharapkan:**
```
Auth Service running on port 3001
Database connected
```

✅ **Service 1 berjalan di port 3001.**

---

## LANGKAH 2: SETUP LARAVEL CONTENT SERVICE (PHP - Port 8080)

### 2.1 Setup Repository

**Buka Terminal 2** (jangan close Terminal 1):

```bash
cd "Novel-go - Copy"
cd novel_core
```

### 2.2 Install Dependencies

```bash
composer install
```

**Output yang diharapkan:**
```
Loading composer repositories with package definitions
Installing dependencies
```

### 2.3 Setup Environment

Copy `.env.example` ke `.env`:

```bash
copy .env.example .env
```

Edit `.env` sesuaikan database:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=novel_db
DB_USERNAME=novel_user
DB_PASSWORD=novel_password
```

### 2.4 Setup Database

Generate key:
```bash
php artisan key:generate
```

Migration & seed (jika diperlukan):
```bash
php artisan migrate --seed
```

### 2.5 Jalankan Laravel Service

```bash
php artisan serve --host=0.0.0.0 --port=8080
```

Atau jika tidak ada artisan:
```bash
php -S 0.0.0.0:8080 -t public
```

**Output yang diharapkan:**
```
Laravel development server started: http://0.0.0.0:8080
[PID] Listening on http://0.0.0.0:8080
```

✅ **Service 2 berjalan di port 8080.**

---

## LANGKAH 3: SETUP COLLECTION SERVICE (Node.js - Port 3002)

### 3.1 Setup Repository

**Buka Terminal 3** (jangan close Terminal 1 & 2):

```bash
cd "Novel-go - Copy"
cd collection-service
```

### 3.2 Install Dependencies

```bash
npm install
```

### 3.3 Setup Environment Variables

**Buat file `.env`:**

```env
PORT=3002
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=novel_db
DB_USER=novel_user
DB_PASSWORD=novel_password
JWT_SECRET=your_jwt_secret_key_here
NODE_ENV=development
```

### 3.4 Jalankan Collection Service

```bash
npm start
```

**Output yang diharapkan:**
```
Collection Service running on port 3002
Database connected
```

✅ **Service 3 berjalan di port 3002.**

---

## LANGKAH 4: TESTING SEMUA SERVICE

### 4.1 Dapatkan IP Device A

Buka **PowerShell/CMD** baru dan jalankan:

```bash
ipconfig
```

Catat IPv4 Address:
```
IPv4 Address . . . . . . . . . . . : 192.168.1.13   ← CATAT INI
```

### 4.2 Test Auth Service

```powershell
# Health check
curl http://192.168.1.13:3001/

# Expected response:
# {"service":"Auth Service","status":"running","database":"connected"}

# Test Register
$json = @{name="Test User";email="test@test.com";password="password123"} | ConvertTo-Json
curl -X POST http://192.168.1.13:3001/auth/register `
  -ContentType "application/json" `
  -Body $json

# Test Login
$json = @{email="test@test.com";password="password123"} | ConvertTo-Json
curl -X POST http://192.168.1.13:3001/auth/login `
  -ContentType "application/json" `
  -Body $json
```

✅ **Auth Service tested.**

### 4.3 Test Laravel Content Service

```powershell
# Get all novels
curl http://192.168.1.13:8080/novels

# Get single novel with chapters
curl http://192.168.1.13:8080/novels/1

# Expected: JSON dengan list novel atau detail novel + chapters
```

✅ **Laravel Service tested.**

### 4.4 Test Collection Service

```powershell
# Health check
curl http://192.168.1.13:3002/

# Expected response:
# {"service":"Collection Service","status":"running","database":"connected"}
```

✅ **Collection Service tested.**

### 4.5 Test Dari Device B (Optional)

Jika sudah ada Device B, test dari sana:

```powershell
# Dari Device B, test Device A
curl http://192.168.1.13:3001/
curl http://192.168.1.13:8080/novels
curl http://192.168.1.13:3002/
```

Semua harus return status **200**.

---

## 📊 VERIFIKASI SETUP

**Checklist sebelum selesai:**

- [ ] Terminal 1: Auth Service running (port 3001)
- [ ] Terminal 2: Laravel Service running (port 8080)
- [ ] Terminal 3: Collection Service running (port 3002)
- [ ] Database (MySQL) connected ke ketiga service
- [ ] Semua endpoint bisa diakses dari Device A:
  - [ ] http://localhost:3001/ → Status 200
  - [ ] http://localhost:8080/novels → Status 200
  - [ ] http://localhost:3002/ → Status 200
- [ ] IP Device A tercatat (untuk config Device B)

---

## 🚀 SETUP CEPAT (JIKA SUDAH PERNAH SETUP)

```bash
# Terminal 1: Auth Service
cd auth-service
npm install
npm start

# Terminal 2: Laravel
cd novel_core
composer install
php artisan serve --host=0.0.0.0 --port=8080

# Terminal 3: Collection Service
cd collection-service
npm install
npm start
```

---

## 🔴 TROUBLESHOOTING

### ❌ "Cannot connect to database"

**Solusi:**
1. Pastikan MySQL server running
2. Cek username/password di `.env`
3. Cek database `novel_db` sudah ada

```bash
# Test MySQL connection
mysql -h localhost -u novel_user -p
# Masukkan password: novel_password
```

### ❌ "Port 3001/8080/3002 already in use"

**Solusi:**
```powershell
# Cek proses yang pakai port
netstat -ano | findstr :3001
netstat -ano | findstr :8080
netstat -ano | findstr :3002

# Bunuh proses (ganti PID)
taskkill /PID 12345 /F
```

### ❌ "npm install" error

**Solusi:**
```bash
# Clear npm cache
npm cache clean --force

# Hapus node_modules
rm -r node_modules
rm package-lock.json

# Install ulang
npm install
```

### ❌ Laravel "Class 'Illuminate\...' not found"

**Solusi:**
```bash
cd novel_core

# Clear cache
php artisan cache:clear
php artisan config:clear

# Dump autoload
composer dump-autoload

# Generate key
php artisan key:generate
```

### ❌ "CORS error" saat Device B akses service

**Solusi untuk Auth Service (Node.js):**

Edit file `auth-service/app.js` atau server file:

```javascript
const cors = require('cors');
app.use(cors({
  origin: '*', // Allow semua
  credentials: true
}));
```

Restart service.

### ❌ "Unable to connect" dari Device B ke Device A

**Solusi:**
1. Pastikan kedua laptop connect ke WiFi/network yang sama
2. Firewall Windows bisa blocking port
   - Buka Windows Defender Firewall
   - Allow ports: 3001, 8080, 3002

3. Test koneksi:
```bash
# Dari Device B
ping 192.168.1.13

# Dari Device A
ping 192.168.1.9
```

---

## 📝 CATATAN PENTING

1. **Urutan startup penting:**
   - MySQL harus running dulu
   - Auth Service kemudian
   - Laravel kemudian
   - Collection terakhir

2. **3 Terminal harus tetap berjalan**
   - Jangan close terminal saat Device B sedang testing

3. **IP bisa berubah** jika laptop restart
   - Cek dengan `ipconfig` sebelum Device B connect

4. **Database credentials**
   - Default: `novel_user` / `novel_password`
   - Sesuaikan jika berbeda

---

## ✅ SELESAI!

Jika semua 3 service running dengan status 200, Device A sudah siap.

**Langkah selanjutnya:**
1. Catat IP Device A (dari `ipconfig`)
2. Setup Device B dengan panduan `SETUP_DEVICE_B.md`
3. Update config Flutter dengan IP yang benar
4. Test Flutter app

**Pertanyaan? Lihat bagian Troubleshooting di atas.**
