<?php
// database_operations.php
require_once 'config.php';

class DatabaseOperations {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    // Sensör verilerini kaydetme
    public function saveSensorData($data) {
        $sql = "INSERT INTO sensor_data (raw_gas, corrected_ppm_gas, ppm_gas, light, 
                soil_moisture, temperature, humidity, pressure) 
                VALUES (:raw_gas, :corrected_ppm_gas, :ppm_gas, :light, 
                :soil_moisture, :temperature, :humidity, :pressure)";
        
        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':raw_gas' => $data['rawgas'],
            ':corrected_ppm_gas' => $data['correctedPPMgas'],
            ':ppm_gas' => $data['PPMgas'],
            ':light' => $data['light'],
            ':soil_moisture' => $data['soil_moisture'],
            ':temperature' => $data['temperature'],
            ':humidity' => $data['humidity'],
            ':pressure' => $data['pressure']
        ]);
    }

    // Sensör verilerini tarih aralığına göre getirme
    public function getSensorData($startDate = null, $endDate = null) {
        $sql = "SELECT * FROM sensor_data";
        $params = [];

        if ($startDate && $endDate) {
            $sql .= " WHERE created_at BETWEEN :start_date AND :end_date";
            $params[':start_date'] = $startDate;
            $params[':end_date'] = $endDate;
        }

        $sql .= " ORDER BY created_at DESC";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    // Eşik değerlerini getirme
    public function getThresholds() {
        $stmt = $this->db->query("SELECT * FROM thresholds ORDER BY id DESC LIMIT 1");
        return $stmt->fetch();
    }

    // Eşik değerlerini güncelleme
    public function updateThresholds($data) {
        $sql = "INSERT INTO thresholds (soil_moisture, light_level, gas_level, 
                air_pressure, temperature, humidity) 
                VALUES (:soil_moisture, :light_level, :gas_level, 
                :air_pressure, :temperature, :humidity)";

        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':soil_moisture' => $data['soil_moisture'],
            ':light_level' => $data['light_level'],
            ':gas_level' => $data['gas_level'],
            ':air_pressure' => $data['air_pressure'],
            ':temperature' => $data['temperature'],
            ':humidity' => $data['humidity']
        ]);
    }

    // LED ayarlarını getirme
    public function getLedSettings() {
        $stmt = $this->db->query("SELECT * FROM led_settings ORDER BY id DESC LIMIT 1");
        return $stmt->fetch();
    }

    // LED ayarlarını güncelleme
    public function updateLedSettings($data) {
        $sql = "INSERT INTO led_settings (red, green, blue, brightness) 
                VALUES (:red, :green, :blue, :brightness)";

        $stmt = $this->db->prepare($sql);
        return $stmt->execute([
            ':red' => $data['red'],
            ':green' => $data['green'],
            ':blue' => $data['blue'],
            ':brightness' => $data['brightness']
        ]);
    }

    // Token kontrolü
    public function validateToken($token) {
        $sql = "SELECT * FROM api_tokens WHERE token = :token AND is_active = 1 
                AND (expires_at IS NULL OR expires_at > NOW())";
        
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':token' => $token]);
        
        if ($stmt->fetch()) {
            $this->updateTokenLastUsed($token);
            return true;
        }
        return false;
    }

    // Token son kullanım zamanını güncelleme
    private function updateTokenLastUsed($token) {
        $sql = "UPDATE api_tokens SET last_used_at = NOW() WHERE token = :token";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':token' => $token]);
    }
}
