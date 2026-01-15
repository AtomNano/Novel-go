# TEAM SETUP GUIDE: 2 Laptops + 1 HP

Panduan ini untuk setup "Novel-go" menggunakan 2 Laptop dan 1 HP dalam satu jaringan Wi-Fi yang sama.

## PERSIAPAN AWAL (WAJIB)
1.  **Matikan Firewall** di kedua Laptop (atau allow port yang digunakan).
2.  **Koneksikan** semua device (Laptop A, Laptop B, HP) ke **Wi-Fi yang sama**.

---

## PERAN DEVICE

### 1. DEVICE A: KOMPUTER / LAPTOP UTAMA (Backend Core)
Device ini akan menjalankan:
-   **Laravel** (Content Service) - Port 8000
-   **Node.js** (Auth Service) - Port 3001
-   **Node.js** (Collection Service) - Port 3002
-   **MySQL Database**

### 2. DEVICE B: LAPTOP KEDUA (Support & Mobile Dev)
Device ini akan menjalankan:
-   **Python** (Social/Interaction Service) - Port 5003
-   **Flutter** (Development / Build ke HP)

---

## LANGKAH 1: CEK IP ADDRESS (Lakukan di KEDUA Laptop)
Buka terminal (CMD) dan ketik:
```bash
ipconfig
```
Cari **IPv4 Address** pada adapter Wi-Fi.
-   Misal IP Laptop A: `192.168.1.10`
-   Misal IP Laptop B: `192.168.1.20`

---

## LANGKAH 2: JALANKAN SERVICE DI DEVICE A (Utama)

**Di Terminal 1 (Laravel):**
Masuk ke folder `novel_core`.
```bash
start_host.bat
# ATAU manual: php -S 0.0.0.0:8000 -t public
```

**Di Terminal 2 (Auth Service):**
Masuk ke folder `auth-service`.
```bash
npm start
```

**Di Terminal 3 (Collection Service):**
Masuk ke folder `collection-service`.
```bash
npm start
```

---

## LANGKAH 3: JALANKAN SERVICE DI DEVICE B (Kedua)

**Di Terminal 1 (Python Social):**
Masuk ke folder `social_service`.
Pastikan file `app.py` baris paling bawah sudah: `app.run(host="0.0.0.0", port=5003)`
```bash
python app.py
```

---

## LANGKAH 4: EDIT CONFIG FLUTTER (Di Device B)

Buka file: `flutter/novel_flutter/lib/config.dart`

Ubah bagian IP sesuai hasil **LANGKAH 1**:

```dart
class Config {
  // IP Laptop A (Yang jalanin Auth & Laravel)
  static const String authCollectionIp = '192.168.1.10'; // Ganti dengan IP Device A
  static const String contentIp = '192.168.1.10';        // Ganti dengan IP Device A

  // IP Laptop B (Yang jalanin Python & Flutter)
  static const String interactionIp = '192.168.1.20';    // Ganti dengan IP Device B
  
  // ... sisanya biarkan ...
}
```

---

## LANGKAH 5: JALANKAN DI HP

1.  Colok HP ke **Device B**.
2.  Jalankan Flutter:
    ```bash
    flutter run
    ```
3.  Aplikasi di HP akan otomatis connect ke Service di Laptop A dan Laptop B via Wi-Fi.

---

## TROUBLESHOOTING

-   **Tidak bisa connect/Loading terus?**
    -   Cek apakah Firewall Windows memblokir port (8000, 3001, 3002, 5003).
    -   Coba ping dari Laptop B ke Laptop A: `ping 192.168.1.10`.
    -   Pastikan HP tidak menggunakan Data Seluler, harus Wi-Fi yang sama.

-   **Gambar tidak muncul?**
    -   Pastikan URL gambar di database menggunakan IP address, bukan `localhost`.
    -   Jika pakai `php artisan storage:link`, pastikan file fisik ada di folder `public/storage`.
