
# Panduan Sharing Service & Koneksi IP

Panduan ini menjelaskan cara membagikan backend services (Docker) ke laptop teman dan menghubungkan aplikasi Flutter dari laptop teman ke backend tersebut.

## Skenario
- **Laptop A (Host)**: Menjalankan Backend (Docker)
- **Laptop B (Client)**: Menjalankan Aplikasi Flutter (Android/iOS)

---

## 1. Laptop A (Host) - Menjalankan Backend

### Cari Tahu IP Address Laptop A
1. Tekan tombol `Windows + R`.
2. Ketik `cmd` lalu Enter.
3. Di Command Prompt, ketik:
   ```cmd
   ipconfig
   ```
4. Cari bagian **Wireless LAN adapter Wi-Fi** (jika pakai WiFi) atau **Ethernet adapter** (jika pakai kabel).
5. Catat **IPv4 Address**. Contoh: `192.168.1.5` atau `192.168.100.12`.

### Bagikan Project ke Teman
Cara paling mudah adalah membagikan seluruh folder project (kecuali `node_modules` dan folder build lain) atau clone dari Git.
1. Pastikan file `docker-compose.yml` ada.
2. Kirim folder project ini ke teman.

### Jalankan Backend
Di terminal (di dalam folder project):
```bash
docker-compose up --build
```
Pastikan semua service running (Auth: 3001, Novel: 8000, Interaction: 5000, Collection: 3002).

> **PENTING**: Laptop A dan Laptop B harus berada di jaringan WiFi/LAN yang SAMA.

---

## 2. Laptop B (Client) - Menjalankan Flutter

### Edit Konfigurasi IP
1. Buka file `lib/config.dart`.
2. Cari variabel `serverIp`.
3. Ganti nilainya dengan **IP Laptop A** yang sudah dicatat tadi.
   
```dart
class Config {
  // GANTI IP INI dengan IP Laptop A (Host Backend)
  static const String serverIp = '192.168.1.5'; // <-- Contoh
  
  // ... sisanya tidak perlu diubah
}
```

### Jalankan Aplikasi Flutter
1. Jalankan aplikasi di HP fisik atau Emulator.
```bash
flutter run
```

### Troubleshooting
Jika aplikasi tidak bisa connect:
1. **Firewall**: Coba matikan sementara Firewall di Laptop A.
   - Search "Firewall & network protection" -> Public network -> Off.
2. **Ping**: Coba ping IP Laptop A dari Laptop B.
   - Buka CMD di Laptop B -> ketik `ping 192.168.1.5` (ganti IP).
   - Jika "Request timed out", berarti koneksi jaringan bermasalah.
3. **Port**: Pastikan port 3001, 8000, 5000, 3002 tidak diblock.

---

## Ringkasan Port Service
- **Auth Service**: 3001
- **Content Service**: 8000
- **Interaction Service**: 5000
- **Collection Service**: 3002
- **Database (MySQL)**: 3306
- **PHPMyAdmin**: 8081
