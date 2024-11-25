<?php
// config.php
define('DB_HOST', 'localhost');
define('DB_NAME', 'yesilarge_api');
define('DB_USER', 'root');
define('DB_PASS', '');

// Token için gizli anahtar
define('JWT_SECRET', 'your_secret_key_here');

// Diğer sabitler
define('TOKEN_EXPIRY_HOURS', 24);
define('API_VERSION', 'v1');

class Database {
    private static $instance = null;
    private $conn;

    private function __construct() {
        try {
            $this->conn = new PDO(
                "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME,
                DB_USER,
                DB_PASS
            );
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        } catch(PDOException $e) {
            die("Connection failed: " . $e->getMessage());
        }
    }

    public static function getInstance() {
        if (self::$instance == null) {
            self::$instance = new Database();
        }
        return self::$instance;
    }

    public function getConnection() {
        return $this->conn;
    }
}
