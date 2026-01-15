# 📱 PANDUAN SETUP DEVICE B (Dengan 2 Service)

Dokumentasi lengkap untuk setup **Python Social Service** dan **Flutter App** di Device B (Laptop Kedua).

---

## 📋 DAFTAR ISI
1. [Prasyarat](#prasyarat)
2. [Langkah 1: Setup Python Social Service](#langkah-1-setup-python-social-service)
3. [Langkah 2: Setup Flutter App](#langkah-2-setup-flutter-app)
4. [Langkah 3: Konfigurasi IP](#langkah-3-konfigurasi-ip)
5. [Langkah 4: Testing](#langkah-4-testing)
6. [Troubleshooting](#troubleshooting)

---

## 🔧 PRASYARAT

Pastikan sudah terinstall:
- **Python 3.8+** (cek: `python --version`)
- **Flutter SDK** (cek: `flutter --version`)
- **Git** (untuk clone repo)
- **VS Code atau Android Studio** (untuk Flutter)

**Device A harus sudah running:**
- Laravel Content Service (Port 8080)
- Auth Service (Port 3001)
- Collection Service (Port 3002)

---

## LANGKAH 1: SETUP PYTHON SOCIAL SERVICE

### 1.1 Clone Repository

```bash
git clone <repository-url>
cd "Novel-go - Copy"
```

### 1.2 Install Dependencies Python

```bash
cd social_service
pip install -r requirements.txt
```

**Output yang diharapkan:**
```
Successfully installed Flask-3.1.2 Jinja2-3.1.6 MarkupSafe-3.0.3 Werkzeug-3.1.5 ...
```

### 1.3 Verifikasi app.py

Pastikan file `social_service/app.py` baris terakhir adalah:
```python
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003, debug=True)
```

✅ **File sudah benar dan tidak perlu diubah.**

### 1.4 Jalankan Python Service

**Buka Terminal BARU** dan jalankan:

```bash
cd social_service
python app.py
```

**Output yang diharapkan:**
```
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5003
 * Running on http://<IP-Device-B>:5003
 * Debugger is active!
```

✅ **Service sudah berjalan di port 5003.**

---

## LANGKAH 2: SETUP FLUTTER APP

### 2.1 Buka Terminal Baru

**Jangan close terminal Python yang sudah berjalan!**

Terminal baru di folder flutter:
```bash
cd flutter/novel_flutter
```

### 2.2 Clean & Get Dependencies

```bash
flutter clean
flutter pub get
```

**Output yang diharapkan:**
```
Getting dependencies...
Got dependencies!
```

### 2.3 Verifikasi Config

Cek file `lib/config.dart` (JANGAN edit dulu):

```bash
cat lib/config.dart
```

---

## LANGKAH 3: KONFIGURASI IP

### 3.1 Dapatkan IP Device A

**Di Device A**, buka Command Prompt/PowerShell dan jalankan:

```bash
ipconfig
```

Cari bagian **WiFi adapter** atau **Ethernet adapter**, catat IPv4 Address:
```
IPv4 Address . . . . . . . . . . . : 192.168.1.13   ← CATAT INI
```

### 3.2 Dapatkan IP Device B (Laptop Sekarang)

**Di Device B (laptop sekarang)**, jalankan:

```bash
ipconfig
```

Catat IPv4 Address Device B:
```
IPv4 Address . . . . . . . . . . . : 192.168.1.9    ← CATAT INI
```

### 3.3 Update Config Flutter

Edit file `flutter/novel_flutter/lib/config.dart`:

**SEBELUM:**
```dart
class Config {
  static const String authCollectionIp = '10.0.2.2';
  static const String contentIp = '10.0.2.2';
  static const String interactionIp = '10.0.2.2';
  ...
}
```

**SESUDAH (ganti dengan IP hasil ipconfig):**
```dart
class Config {
  // IP DEVICE A (Laptop dengan Laravel, Auth, Collection)
  static const String authCollectionIp = '192.168.1.13';  // ← IP Device A
  
  // IP DEVICE A (Laravel Content Service)
  static const String contentIp = '192.168.1.13';         // ← IP Device A
  
  // IP DEVICE B (Python Social Service & Flutter)
  static const String interactionIp = '192.168.1.9';      // ← IP Device B (SEKARANG)
  
  // =========================================================
  // BASE URL SERVICES
  // =========================================================
  
  static const String baseUrlAuth = 'http://$authCollectionIp:3001';
  static const String baseUrlNovel = 'http://$contentIp:8080';
  static const String baseUrlInteraction = 'http://$interactionIp:5003';
  static const String baseUrlCollection = 'http://$authCollectionIp:3002';
}
```

**✅ PENTING: Ganti `192.168.1.13` dan `192.168.1.9` dengan IP hasil ipconfig dari Device A dan B!**

---

## LANGKAH 4: TESTING

### 4.1 Test Python Service

Buka PowerShell/CMD **BARU** dan jalankan:

```powershell
curl http://192.168.1.9:5003/
```

**Output yang diharapkan:**
```json
{
  "service": "Social & Feedback Service",
  "status": "running",
  "endpoints": {...}
}
```

✅ **Python service bisa diakses.**

### 4.2 Test Semua Service dari Device B

```powershell
# Test Device A Services
curl http://192.168.1.13:3001/         # Auth Service
curl http://192.168.1.13:8080/novels   # Laravel Content
curl http://192.168.1.13:3002/         # Collection Service

# Test Device B Service
curl http://192.168.1.9:5003/          # Python Social Service
```

Semua harus return **status 200**.

### 4.3 Jalankan Flutter App

Di terminal flutter:

```bash
flutter run
```

Atau untuk Android emulator yang spesifik:
```bash
flutter run -d emulator-5554
```

**Tunggu sampai app fully loaded (1-2 menit).**

### 4.4 Test di Flutter

1. **Tap "Register"** → Daftar akun baru
2. **Tap "Login"** → Login dengan akun yang baru dibuat
3. **Swipe atau tap** Novel dari list (dari Laravel Service)
4. **Read Chapter** → Lihat konten dari Laravel
5. **Tap "Comments"** → Lihat/buat comment (dari Python Service)

✅ **Jika semua berjalan, setup berhasil!**

---

## 📊 VERIFIKASI SETUP

**Checklist sebelum testing:**

- [ ] Python service running di port 5003 (terminal 1)
- [ ] Flutter terminal ready (terminal 2)
- [ ] Config Flutter sudah update dengan IP yang benar
- [ ] Device A service semua running:
  - [ ] Port 3001 (Auth) - Status 200
  - [ ] Port 8080 (Laravel) - Status 200
  - [ ] Port 3002 (Collection) - Status 200
- [ ] Device B service running:
  - [ ] Port 5003 (Python) - Status 200

---

## 🚀 SETUP CEPAT (JIKA SUDAH PERNAH SETUP)

Jika sudah ada folder `social_service` dan `flutter`:

```bash
# Terminal 1: Python Service
cd social_service
pip install -r requirements.txt
python app.py

# Terminal 2: Flutter
cd flutter/novel_flutter
flutter pub get
# (Update IP di config.dart)
flutter run
```

---

## 🔴 TROUBLESHOOTING

### ❌ "ModuleNotFoundError: No module named 'flask'"

**Solusi:**
```bash
cd social_service
pip install -r requirements.txt
```

### ❌ "Unable to connect to remote server" saat test curl

**Solusi:**
1. Pastikan Python service masih running
2. Cek IP dengan `ipconfig` - mungkin berubah
3. Update config Flutter dengan IP yang benar
4. Firewall Windows? Buka port 5003

**Test firewall:**
```bash
# Dari Device B
curl http://192.168.1.9:5003/

# Dari Device A
curl http://localhost:5003/
```

### ❌ Flutter app tidak bisa koneksi ke service

**Solusi:**
1. Restart Flutter app (hot restart: tekan `R`)
2. Cek IP di `lib/config.dart` sudah benar
3. Pastikan Device A service semua running
4. Cek `Console` tab di Flutter untuk error detail

### ❌ Port sudah dipakai

**Cek proses yang pakai port:**
```bash
# PowerShell
netstat -ano | findstr :5003

# Bunuh proses (ganti PID)
taskkill /PID 12345 /F
```

---

## 📝 CATATAN PENTING

1. **IP bisa berubah** jika laptop restart atau pindah WiFi
   - Cek ulang dengan `ipconfig` sebelum testing

2. **Terminal Python harus tetap berjalan**
   - Jangan close terminal saat testing Flutter

3. **Folder yang berisi spasi** (Novel-go - Copy)
   - Bisa menyebabkan build error di Android
   - Jika error, pindah ke folder tanpa spasi

4. **Device harus sama network**
   - Kedua laptop harus connect ke WiFi/network yang sama

---

## ✅ SELESAI!

Jika semua langkah berhasil, setup Device B dengan 2 service sudah lengkap.

**Untuk setup ke laptop teman:**
1. Copy-paste panduan ini
2. Ganti IP sesuai hasil `ipconfig`
3. Follow langkah 1-4

**Pertanyaan? Lihat bagian Troubleshooting di atas.**
