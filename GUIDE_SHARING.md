
# Panduan Setup Tim Terdistribusi (3 Laptop)

Panduan ini untuk setup tim dengan pembagian tugas:
1.  **Laptop A (Anda)**: Menjalankan **Node.js Services** (Auth & Collection).
2.  **Laptop B (Teman 1)**: Menjalankan **Laravel Service** (Content).
3.  **Laptop C (Teman 2)**: Menjalankan **Aplikasi Flutter** dan **Python Service** (Interaction).

---

## Prasyarat Wajib
1.  **Satu Jaringan**: Ketiga laptop (dan HP jika pakai HP fisik) **WAJIB** terhubung ke WiFi/Tethering yang SAMA.
2.  **Firewall Off**: Matikan firewall di Laptop A, B, dan C agar bisa saling akses.

---

## Langkah 1: Cek IP Address Masing-Masing

Setiap orang (Laptop A, B, dan C) harus melakukan ini:
1.  Buka CMD (`Windows + R`, ketik `cmd`).
2.  Ketik `ipconfig`.
3.  Catat **IPv4 Address** (misal: `192.168.1.10`, `192.168.1.11`, dll).

**Contoh Hasil Catatan:**
- IP Laptop A (Node.js): `192.168.1.5`
- IP Laptop B (Laravel): `192.168.1.6`
- IP Laptop C (Flutter/Python): `192.168.1.7`

---

## Langkah 2: Jalankan Service Backend

### Di Laptop A (Node.js)
Jalankan container Auth & Collection:
```bash
docker-compose up --build auth-service collection-service mysql phpmyadmin
```
Pastikan port running: **3001** (Auth) dan **3002** (Collection).

### Di Laptop B (Laravel)
Jalankan container Core (Lumen):
```bash
docker-compose up --build novel_core
```
Pastikan port running: **8080** (Content / Core).
*(Catatan: Container Laravel di Laptop B harus konek ke Database di Laptop A. Pastikan di `docker-compose.yml` Laptop B, `DB_HOST` mengarah ke IP Laptop A, atau jika ribet, jalankan MySQL sendiri di Laptop B tetapi datanya jadi terpisah)*.
**OPSI LEBIH MUDAH UNTUK DATABASE:**
Agar tidak pusing connect database antar laptop, sebaiknya **tiap laptop backend menjalankan MySQL-nya sendiri** (dummy data masing-masing), atau putuskan Laptop A sebagai "Database Pusat" dan Laptop B ubah `.env` / `docker-compose.yml` nya bagian `DB_HOST` ke IP Laptop A.

### Di Laptop C (Python & Flutter)
1.  Jalankan container Social (Python):
    ```bash
    docker-compose up --build social_service
    ```
    Pastikan port running: **5003**.
    
2.  **Konfigurasi Flutter**:
    Buka `lib/config.dart` dan isi IP sesuai catatan tadi.

    ```dart
    class Config {
      // Masukkan IP Laptop A
      static const String authCollectionIp = '192.168.1.5'; 

      // Masukkan IP Laptop B
      static const String contentIp = '192.168.1.6';

      // Karena Python jalan di laptop ini sendiri (Laptop C)
      // Jika pakai Emulator Android: gunakan '10.0.2.2'
      // Jika pakai HP Fisiki: gunakan IP Laptop C ('192.168.1.7')
      static const String interactionIp = '10.0.2.2'; 
    }
    ```

3.  **Jalankan Flutter**:
    ```bash
    flutter run
    ```

---

## Troubleshooting Koneksi
Jika Flutter gagal connect ke salah satu service:
1.  **Ping Test**: Dari Laptop C, coba ping IP Laptop A dan B.
    - `ping 192.168.1.5`
    - Jika RTO (Request Timed Out) -> Cek koneksi WiFi atau matikan Firewall.
2.  **Cek Browser**: Dari Laptop C, buka browser dan akses URL service teman.
    - Buka `http://192.168.1.5:3001` (Cek Auth Service Laptop A)
    - Jika muncul response (walau error), berarti koneksi masuk.
3.  **Cek Port**:
    - Auth: **3001**
    - Content (Legacy/New): **8080**
    - Interaction (New): **5003**
    - Collection: **3002**
