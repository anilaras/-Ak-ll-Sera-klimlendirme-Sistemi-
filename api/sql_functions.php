<?php
// sql_functions.php
require_once 'db.php';

function insertSensorData($data) {
    $pdo = getDbConnection();
    $stmt = $pdo->prepare("INSERT INTO sensor_data (raw_gas, corrected_ppm_gas, ppm_gas, light, soil_moisture, temperature, humidity, pressure) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->execute([$data['rawgas'], $data['correctedPPMgas'], $data['PPMgas'], $data['light'], $data['soil_moisture'], $data['temperature'], $data['humidity'], $data['pressure']]);
}

function getSensorData($startDate = null, $endDate = null) {
    $pdo = getDbConnection();
    if ($startDate && $endDate) {
        $stmt = $pdo->prepare("SELECT * FROM sensor_data WHERE timestamp BETWEEN ? AND ?");
        $stmt->execute([$startDate, $endDate]);
    } else {
        $stmt = $pdo->prepare("SELECT * FROM sensor_data");
        $stmt->execute();
    }
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function getThresholds() {
    $pdo = getDbConnection();
    $stmt = $pdo->prepare("SELECT * FROM thresholds");
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}

function updateThresholds($parameter, $value) {
    $pdo = getDbConnection();
    $stmt = $pdo->prepare("UPDATE thresholds SET value = ? WHERE parameter_name = ?");
    $stmt->execute([$value, $parameter]);
}

function getLedSettings() {
    $pdo = getDbConnection();
    $stmt = $pdo->prepare("SELECT * FROM led_settings WHERE id = 1");
    $stmt->execute();
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

function updateLedSettings($red, $green, $blue, $brightness) {
    $pdo = getDbConnection();
    $stmt = $pdo->prepare("UPDATE led_settings SET red = ?, green = ?, blue = ?, brightness = ? WHERE id = 1");
    $stmt->execute([$red, $green, $blue, $brightness]);
}

function validateToken($token) {
    $pdo = getDbConnection();
    $stmt = $pdo->prepare("SELECT * FROM api_tokens WHERE token = ? AND expiry_date > NOW()");
    $stmt->execute([$token]);
    return $stmt->fetch(PDO::FETCH_ASSOC) !== false;
}
?>
