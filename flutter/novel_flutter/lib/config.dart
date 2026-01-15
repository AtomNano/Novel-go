class Config {
  // =========================================================
  // KONFIGURASI TEAM SETUP (2 Laptops + 1 HP)
  // =========================================================
  
  // 1. IP DEVICE A (Laptop Utama: Laravel, Auth, Collection, Database)
  // Masukkan IP Address dari Laptop A (Cek pakai `ipconfig`)
  static const String authCollectionIp = '10.0.2.2'; // GANTI INI dengan IP Laptop A, misal: '192.168.1.10'

  // 2. IP DEVICE A (Laravel Content Service)
  // Biasanya sama dengan authCollectionIp jika di satu laptop
  static const String contentIp = '10.0.2.2';        // GANTI INI dengan IP Laptop A, misal: '192.168.1.10'

  // 3. IP DEVICE B (Laptop Kedua: Python Service & Flutter)
  // Masukkan IP Address dari Laptop B (Cek pakai `ipconfig`), TEMPAT ANDA RUN FLUTTER
  static const String interactionIp = '10.0.2.2';    // GANTI INI dengan IP Laptop B, misal: '192.168.1.20'

  // =========================================================
  // BASE URL SERVICES
  // =========================================================
  
  // Auth Service (Node.js) - Port 3001
  static const String baseUrlAuth = 'http://$authCollectionIp:3001';
  
  // Content Service (PHP) - Port 8080
  static const String baseUrlNovel = 'http://$contentIp:8080';
  
  // Interaction Service (Python/Flask) - Port 5003
  static const String baseUrlInteraction = 'http://$interactionIp:5003';
  
  // Collection Service (Node.js) - Port 3002
  static const String baseUrlCollection = 'http://$authCollectionIp:3002';
}
