class Config {
  // =========================================================
  // KONFIGURASI IP SERVER
  // =========================================================
  // Ganti IP di bawah ini dengan IP Laptop Server (Laptop Teman)
  // Cara cek IP di Windows: Buka CMD -> ketik 'ipconfig' -> lihat IPv4 Address
  // Contoh: '192.168.1.5', '192.168.100.12', dll.
  // 
  // Jika pakai Emulator Android di laptop yang sama dengan backend: gunakan '10.0.2.2'
  // Jika pakai HP Fisik / Laptop lain: Wajib ganti ke IP Laptop Server (misal '192.168.x.x')
  
  static const String serverIp = '10.0.2.2'; // <--- GANTI INI SESUAI KEBUTUHAN

  // =========================================================
  // BASE URL SERVICES
  // =========================================================
  
  // Auth Service (Node.js) - Port 3001
  static const String baseUrlAuth = 'http://$serverIp:3001';
  
  // Content Service (PHP) - Port 8000
  static const String baseUrlNovel = 'http://$serverIp:8000';
  
  // Interaction Service (Python/Flask) - Port 5000
  static const String baseUrlInteraction = 'http://$serverIp:5000';
  
  // Collection Service (Node.js) - Port 3002
  static const String baseUrlCollection = 'http://$serverIp:3002';
}
