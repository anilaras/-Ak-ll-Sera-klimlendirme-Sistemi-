-- Sensör Verileri Tablosu
CREATE TABLE sensor_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    raw_gas FLOAT,
    corrected_ppm_gas FLOAT,
    ppm_gas FLOAT,
    light INT,
    soil_moisture INT,
    temperature FLOAT,
    humidity FLOAT,
    pressure FLOAT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Eşik Değerleri Tablosu
CREATE TABLE thresholds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    parameter_name VARCHAR(50) UNIQUE,
    value FLOAT
);

-- LED Ayarları Tablosu
CREATE TABLE led_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    red INT,
    green INT,
    blue INT,
    brightness INT
);

-- Token Tablosu
CREATE TABLE api_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(255),
    expiry_date DATETIME
);
