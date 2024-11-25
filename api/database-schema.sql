-- Sensör verileri tablosu
CREATE TABLE sensor_data (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    raw_gas FLOAT,
    corrected_ppm_gas FLOAT,
    ppm_gas FLOAT,
    light INT,
    soil_moisture INT,
    temperature FLOAT,
    humidity FLOAT,
    pressure FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Eşik değerleri tablosu
CREATE TABLE thresholds (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    soil_moisture INT,
    light_level INT,
    gas_level FLOAT,
    air_pressure FLOAT,
    temperature FLOAT,
    humidity FLOAT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- LED ayarları tablosu
CREATE TABLE led_settings (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    red TINYINT UNSIGNED,
    green TINYINT UNSIGNED,
    blue TINYINT UNSIGNED,
    brightness TINYINT UNSIGNED,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- API token tablosu
CREATE TABLE api_tokens (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    last_used_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL
);

-- Varsayılan değerleri ekleme
INSERT INTO thresholds (soil_moisture, light_level, gas_level, air_pressure, temperature, humidity) 
VALUES (30, 500, 1000, 1013, 25, 60);

INSERT INTO led_settings (red, green, blue, brightness) 
VALUES (128, 0, 128, 100);
