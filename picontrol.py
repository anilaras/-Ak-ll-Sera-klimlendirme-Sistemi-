import serial
import requests
import json
import RPi.GPIO as GPIO
import board
import neopixel
import time

# Raspberry Pi GPIO ve WS2811 ayarları
GPIO.setmode(GPIO.BCM)
RELAY_PIN = 17  # Röle kontrolü için GPIO pini
FAN_PIN = 27    # Fan kontrolü için GPIO pini
LED_PIN = board.D18  # WS2811 LED şerit için
NUM_PIXELS = 12  # WS2811 LED şerit uzunluğu
ORDER = neopixel.GRB

GPIO.setup(RELAY_PIN, GPIO.OUT)
GPIO.setup(FAN_PIN, GPIO.OUT)
pixels = neopixel.NeoPixel(LED_PIN, NUM_PIXELS, brightness=0.0, auto_write=False, pixel_order=ORDER)

# UART bağlantısı ayarları
SERIAL_PORT = '/dev/ttyUSB0'
BAUD_RATE = 115200
serial_conn = serial.Serial(SERIAL_PORT, BAUD_RATE)

# Sunucudan eşik değerlerini almak ve sensör verilerini göndermek için API ayarları
THRESHOLD_API_URL = "http://yesilarge.online/api/v1/thresholds"
SENSOR_DATA_API_URL = "http://yesilarge.online/api/v1/sensor-data"  # Sensör verisi gönderme URL'i
LED_SETTINGS_API_URL = "http://yesilarge.online/api/v1/led-settings"
headers = {"Authorization": "cokgizli"}

# Default eşik değerleri ve varsayılan LED rengi
DEFAULT_THRESHOLDS = {
    "soil_moisture": 30,
    "light_level": 25,
    "gas_level": 20,
    "air_pressure": 300,
    "temperature": 400,
    "humidity": 1000,
}

LED_THRESHOLDS = {
    "red": "128",
    "green": "0",
    "blue": "128",
    "brightness": "100",
}

thresholds = DEFAULT_THRESHOLDS  # Başlangıçta default değerler
led_thresholds = LED_THRESHOLDS  # Başlangıçta default değerler

# Su pompası, fan ve LED kontrol fonksiyonları
def control_relay(state):
    GPIO.output(RELAY_PIN, GPIO.HIGH if state else GPIO.LOW)

def control_fan(state):
    GPIO.output(FAN_PIN, GPIO.HIGH if state else GPIO.LOW)

def control_led(color, brightness):
    pixels.fill(color)
    pixels.brightness = brightness
    pixels.show()

def get_thresholds():
    try:
        response = requests.get(THRESHOLD_API_URL, headers=headers)
        if response.status_code == 200:
            raw_thresholds = response.json()
            # Yalnızca integer'a dönüştürülebilen değerleri işleyin
            thresholds = {}
            for key, value in raw_thresholds.items():
                try:
                    thresholds[key] = int(value)  # Eğer value bir sayıysa integer'a dönüştür
                except ValueError:
                    thresholds[key] = value  # Eğer sayı değilse olduğu gibi bırak
            return thresholds
        else:
            print("Eşik değerlerini alma hatası:", response.status_code)
            return None
    except Exception as e:
        print("Sunucu bağlantı hatası:", e)
        return None

def get_led_settings():
    try:
        response = requests.get(LED_SETTINGS_API_URL, headers=headers)
        if response.status_code == 200:
            settings = response.json()
            return settings
        else:
            print("LED değerlerini alma hatası:", response.status_code)
            return None
    except Exception as e:
        print("Sunucu bağlantı hatası:", e)
        return None

def send_sensor_data(data):
    try:
        response = requests.post(SENSOR_DATA_API_URL, json=data, headers=headers)
        if response.status_code == 200:
            print("Sensör verileri başarıyla gönderildi.")
        else:
            print("Sensör verilerini gönderme hatası:", response.status_code)
    except Exception as e:
        print("Sunucuya veri gönderim hatası:", e)

# Ana döngü
last_threshold_update = 0  # Eşik değerlerinin en son güncellendiği zaman
THRESHOLD_UPDATE_INTERVAL = 10  # Eşik değerlerini güncelleme aralığı (saniye)
SENSOR_SEND_INTERVAL = 15  # Sensör verilerini gönderme aralığı (saniye)
last_sensor_send = 0
led_on = False  # LED durumu

try:
    while True:
        current_time = time.time()

        # Eşik değerlerini güncelleme (her 10 saniyede bir)
        if current_time - last_threshold_update > THRESHOLD_UPDATE_INTERVAL:
            new_thresholds = get_thresholds()
            new_led_thresholds = get_led_settings()
            if new_thresholds:
                thresholds = new_thresholds  # Yeni değerler başarılıysa güncelle
                led_thresholds = new_led_thresholds
                print("Eşik değerleri ve renk güncellendi:", thresholds)
            else:
                print("Sunucuya ulaşılamadığı için en son eşik değerleri kullanılacak.")
            last_threshold_update = current_time

        # UART üzerinden JSON verisini okuma
        if serial_conn.in_waiting > 0:
            line = serial_conn.readline().decode('utf-8').strip()
            try:
                sensor_data = json.loads(line)
            except json.JSONDecodeError:
                print("Geçersiz JSON verisi:", line)
                continue

            # Sensör verilerini eşik değerleri ile karşılaştır
            soil_moisture = sensor_data.get("soil_moisture", 0)
            light = sensor_data.get("light", 0)  # LDR ışık değeri
            gas = sensor_data.get("rawgas", 0)
            pressure = sensor_data.get("pressure", 0)
            temperature = sensor_data.get("temperature", 0)
            humidity = sensor_data.get("humidity", 0)
            print(str(soil_moisture) + " " + str(light) + " " + str(gas) + " " + str(pressure) + " " + str(temperature) + " " + str(humidity) + " \n" )
            # Su pompası kontrolü
            if soil_moisture < thresholds["soil_moisture"]:
                control_relay(True)
                print("Su pompası açıldı.")
            else:
                print("Su pompası kapatıldı.")
                control_relay(False)

            # Fan kontrolü (sıcaklık, nem veya gaz seviyesi yüksekse)
            if temperature > thresholds["temperature"] or \
               humidity > thresholds["humidity"] or \
               gas > thresholds["gas_level"]:
                control_fan(True)
                print("Fan açıldı.")
            else:
                control_fan(False)

            # LED şeridi kontrolü: Ortam ışığı düşükse LED'leri yavaşça aç
            led_color_red = int(led_thresholds.get("red"))  # Sunucudan veya varsayılan renk
            led_color_green = int(led_thresholds.get("green"))  # Sunucudan veya varsayılan renk
            led_color_blue = int(led_thresholds.get("blue"))  # Sunucudan veya varsayılan renk
            led_color = (led_color_red, led_color_green, led_color_blue)
            brightness = min(max(light / 1023, 0.1), 1.0)  # Parlaklığı ışık değerine göre 0.1-1.0 arası ayarla
            if light < thresholds["light_level"]:
                control_led(tuple(led_color), brightness)  # Renk ve parlaklığı LED şeridine uygula
                print("LED şeridi açıldı.")
            else:
                control_led((0, 0, 0), 0)  # LED'leri kapat
                print("LED şeridi kapatıldı.")

            # Sensör verilerini belirli aralıklarla sunucuya gönderme
            if current_time - last_sensor_send > SENSOR_SEND_INTERVAL:
                send_sensor_data(sensor_data)
                last_sensor_send = current_time

            # Diğer sensör kontrolleri
            if pressure < thresholds["air_pressure"]:
                print("Basınç seviyesi düşük.")

        # LED parlaklık geçiş adımını güncelle

        time.sleep(0.1)  # Program akışını hafifletmek için kısa bir gecikme

except KeyboardInterrupt:
    print("Program sonlandırıldı.")

finally:
    control_led((0,0,0),0)
    # GPIO pinleri temizle
    GPIO.cleanup()
    serial_conn.close()
