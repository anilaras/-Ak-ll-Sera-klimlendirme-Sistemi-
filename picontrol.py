import serial
import json
import time
import requests
from datetime import datetime
import RPi.GPIO as GPIO
from rpi_ws281x import *
import numpy as np
from picamera import PiCamera
import socket
import netifaces
import threading
import os

# Pin tanımlamaları
RELAY_PIN = 18  # Su pompası rölesi
FAN_PIN = 23    # Fan kontrolü
LED_COUNT = 60  # WS2811 LED sayısı
LED_PIN = 18    # WS2811 veri pini
LED_FREQ_HZ = 800000
LED_DMA = 10
LED_BRIGHTNESS = 255
LED_CHANNEL = 0
LED_INVERT = False

# Varsayılan eşik değerleri
DEFAULT_THRESHOLDS = {
    'soil_moisture': 30,
    'light_level': 500,
    'gas_level': 1000,
    'air_pressure': 1013,
    'temperature': 25,
    'humidity': 60,
    'led_color': (128, 0, 128),  # Mor renk
    'led_brightness': 100
}

headers = {"Authorization": "cokgizli"}

class SensorSystem:
    def __init__(self):
        # GPIO ayarları
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(RELAY_PIN, GPIO.OUT)
        GPIO.setup(FAN_PIN, GPIO.OUT)
        
        # WS2811 LED strip ayarları
        self.strip = Adafruit_NeoPixel(LED_COUNT, LED_PIN, LED_FREQ_HZ, LED_DMA, LED_INVERT, LED_BRIGHTNESS, LED_CHANNEL)
        self.strip.begin()
        
        # Serial port ayarları
        self.serial = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
        
        # Kamera ayarları
        self.camera = PiCamera()
        self.camera.resolution = (1920, 1080)
        
        # LCD ekran ayarları
        self.lcd = ks0108(port=0, device=0, bus_speed_hz=8000000)
        
        # Durum değişkenleri
        self.current_thresholds = DEFAULT_THRESHOLDS.copy()
        self.last_photo_time = time.time()
        self.last_threshold_update = time.time()
        self.led_fade_start = 0
        self.led_target_brightness = 0
        
        # API endpoint'leri
        self.API_BASE_URL = "http://yesilarge.online/api/v1/"
        
    def get_network_info(self):
#        """Ağ bilgilerini alma"""
        ip_address = ""
        network_name = ""
        
        # Wi-Fi kontrolü
        try:
            wifi = netifaces.ifaddresses('wlan0')
            if netifaces.AF_INET in wifi:
                ip_address = wifi[netifaces.AF_INET][0]['addr']
                # Wi-Fi ağ adını alma
                with open('/etc/NetworkManager/system-connections/*') as f:
                    for line in f:
                        if "ssid=" in line:
                            network_name = line.split('=')[1].strip()
                            break
        except:
            # Ethernet kontrolü
            try:
                eth = netifaces.ifaddresses('eth0')
                if netifaces.AF_INET in eth:
                    ip_address = eth[netifaces.AF_INET][0]['addr']
                    network_name = "Ethernet"
            except:
                pass
                
        return ip_address, network_name

    def fade_leds(self, target_brightness):
#        """LED'leri yavaşça açma"""
        current_time = time.time()
        elapsed_time = current_time - self.led_fade_start
        
        if elapsed_time > 5:  # 5 saniye sonra tam parlaklık
            brightness = target_brightness
        else:
            brightness = int((elapsed_time / 5) * target_brightness)
            
        return brightness

    def set_led_color(self, color, brightness):
#        """LED şerit rengini ve parlaklığını ayarlama"""
        r, g, b = color
        for i in range(LED_COUNT):
            self.strip.setPixelColor(i, Color(
                int(r * brightness / 255),
                int(g * brightness / 255),
                int(b * brightness / 255)
            ))
        self.strip.show()

    def get_thresholds(self):
#        """Sunucudan eşik değerlerini alma"""
        try:
            response = requests.get(f"{self.API_BASE_URL}/thresholds", headers= headers)
            if response.status_code == 200:
                self.current_thresholds = response.json()
                return True
        except:
            return False
        return False

    def send_sensor_data(self, sensor_data):
#        """Sensör verilerini sunucuya gönderme"""
        try:
            requests.post(f"{self.API_BASE_URL}/sensor-data", json=sensor_data, headers=headers)
        except:
            pass

    def send_photo(self):
#        """Fotoğraf çekip sunucuya gönderme"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        photo_path = f"/tmp/plant_{timestamp}.jpg"
        
        self.camera.capture(photo_path)
        
        try:
            with open(photo_path, 'rb') as photo:
                files = {'photo': photo}
                requests.post(f"{self.API_BASE_URL}/upload-photo", files=files, headers=headers)
            os.remove(photo_path)
        except:
            pass

    def process_sensor_data(self, sensor_data):
#        """Sensör verilerini işleme"""
        # Su pompası kontrolü
        if sensor_data['soil_moisture'] < self.current_thresholds['soil_moisture']:
            GPIO.output(RELAY_PIN, GPIO.HIGH)
        else:
            GPIO.output(RELAY_PIN, GPIO.LOW)

        # Fan kontrolü
        if (sensor_data['humidity'] > self.current_thresholds['humidity'] or 
            sensor_data['gas_level'] > self.current_thresholds['gas_level']):
            GPIO.output(FAN_PIN, GPIO.HIGH)
        else:
            GPIO.output(FAN_PIN, GPIO.LOW)

        # LED kontrolü
        if sensor_data['light_level'] < self.current_thresholds['light_level']:
            if self.led_fade_start == 0:
                self.led_fade_start = time.time()
            
            brightness = self.fade_leds(self.current_thresholds['led_brightness'])
            self.set_led_color(self.current_thresholds['led_color'], brightness)
        else:
            self.set_led_color((0, 0, 0), 0)
            self.led_fade_start = 0

    def run(self):
#        """Ana döngü"""
        while True:
            # Sensör verilerini okuma
            if self.serial.in_waiting:
                try:
                    data = self.serial.readline().decode('utf-8').strip()
                    sensor_data = json.loads(data)
                    
                    # Sensör verilerini işleme
                    self.process_sensor_data(sensor_data)
                    # Sensör verilerini sunucuya gönderme
                    self.send_sensor_data(sensor_data)
                except:
                    continue

            # Eşik değerlerini güncelleme (10 saniyede bir)
            current_time = time.time()
            if current_time - self.last_threshold_update >= 10:
                self.get_thresholds()
                self.last_threshold_update = current_time

            # Fotoğraf çekme (1 saatte bir)
            if current_time - self.last_photo_time >= 3600:
                self.send_photo()
                self.last_photo_time = current_time

            time.sleep(0.1)

if __name__ == "__main__":
    try:
        system = SensorSystem()
        system.run()
    except KeyboardInterrupt:
        GPIO.cleanup()
        print("Program sonlandırıldı.")
