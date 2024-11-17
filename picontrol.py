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
NUM_PIXELS = 30  # WS2811 LED şerit uzunluğu
ORDER = neopixel.GRB

GPIO.setup(RELAY_PIN, GPIO.OUT)
GPIO.setup(FAN_PIN, GPIO.OUT)
pixels = neopixel.NeoPixel(LED_PIN, NUM_PIXELS, brightness=0.0, auto_write=False, pixel_order=ORDER)

# UART bağlantısı ayarları
SERIAL_PORT = '/dev/ttyUSB0'
BAUD_RATE = 9600
serial_conn = serial.Serial(SERIAL_PORT, BAUD_RATE)

# Sunucudan eşik değerlerini almak ve sensör verilerini göndermek için API ayarları
THRESHOLD_API_URL = "http://yourserver.com/api/thresholds"
SENSOR_DATA_API_URL = "http://yourserver.com/api/sensor-data"  # Sensör verisi gönderme URL'i

# Default eşik değerleri ve varsayılan LED rengi
DEFAULT_THRESHOLDS = {
    "soil_moisture_threshold": 30,
    "temperature_threshold": 25,
    "soil_moisture_led_threshold": 20,
    "light_threshold": 300,
    "gas_threshold": 400,
    "pressure_threshold": 1000,
    "humidity_threshold": 60,
    "led_color": (128, 0, 128)  # Varsayılan LED rengi (mor)
}
thresholds = DEFAULT_THRESHOLDS  # Başlangıçta default değerler

# Su pompası, fan ve LED kontrol fonksiyonları
def control_relay(state):
    GPIO.output(RELAY_PIN, GPIO.HIGH if state else GPIO.LOW)

def control_fan(state):
    GPIO.output(FAN_PIN, GPIO.HIGH if state else GPIO.LOW)

def control_led(color, brightness):
    pixels.fill(color)
    pixels.brightness = brightness
    pixels.show()

# LED fade in kontrolü için değişkenler
fade_in_progress = False
fade_in_target_brightness = 0.0
fade_in_current_brightness = 0.0
fade_in_start_time = 0
fade_in_duration = 5  # 5 saniyelik fade süresi
fade_in_steps = 50  # 50 adımda parlaklık artışı
fade_in_step_delay = fade_in_duration / fade_in_steps

def start_fade_in(target_color, target_brightness):
    global fade_in_progress, fade_in_target_brightness, fade_in_current_brightness, fade_in_start_time
    fade_in_progress = True
    fade_in_target_brightness = target_brightness
    fade_in_current_brightness = 0.0
    fade_in_start_time = time.time()
    control_led(target_color, fade_in_current_brightness)

def fade_in_led_step():
    global fade_in_progress, fade_in_current_brightness
    if fade_in_progress:
        elapsed = time.time() - fade_in_start_time
        step = min(elapsed / fade_in_duration, 1.0)  # 0 ile 1 arasında normalleştirilmiş adım
        fade_in_current_brightness = step * fade_in_target_brightness
        control_led(thresholds["led_color"], fade_in_current_brightness)
        
        # Hedef parlaklığa ulaşıldıysa geçişi durdur
        if step >= 1.0:
            fade_in_progress = False

def get_thresholds():
    try:
        response = requests.get(THRESHOLD_API_URL)
        if response.status_code == 200:
            return response.json()
        else:
            print("Eşik değerlerini alma hatası:", response.status_code)
            return None
    except Exception as e:
        print("Sunucu bağlantı hatası:", e)
        return None

def send_sensor_data(data):
    try:
        response = requests.post(SENSOR_DATA_API_URL, json=data)
        if response.status_code == 200:
            print("Sensör verileri başarıyla gönderildi.")
        else:
            print("Sensör verilerini gönderme hatası:", response.status_code)
    except Exception as e:
        print("Sunucuya veri gönderim hatası:", e)

# Hava nemi kontrolü ve sulama pompası açma-kapama işlemi
def humidity_control(humidity):
    if humidity < thresholds["humidity_threshold"]:
        control_relay(True)  # Su pompasını aç
        print("Hava nemi düşük, su pompası 1 saniyeliğine açıldı.")
        time.sleep(1)  # 1 saniye bekle
        control_relay(False)  # Su pompasını kapat
    else:
        control_relay(False)  # Nem yüksekse su pompası kapalı kalır

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
            if new_thresholds:
                thresholds = new_thresholds  # Yeni değerler başarılıysa güncelle
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
            gas = sensor_data.get("gas", 0)
            pressure = sensor_data.get("pressure", 0)
            temperature = sensor_data.get("temperature", 0)
            humidity = sensor_data.get("humidity", 0)

            # Hava nemi kontrolü
            humidity_control(humidity)

            # Su pompası kontrolü
            if soil_moisture < thresholds["soil_moisture_threshold"]:
                control_relay(True)
                print("Su pompası açıldı.")
            else:
                control_relay(False)

            # Fan kontrolü (sıcaklık, nem veya gaz seviyesi yüksekse)
            if temperature > thresholds["temperature_threshold"] or \
               humidity > thresholds["humidity_threshold"] or \
               gas > thresholds["gas_threshold"]:
                control_fan(True)
                print("Fan açıldı.")
            else:
                control_fan(False)

            # LED şeridi kontrolü: Ortam ışığı düşükse LED'leri yavaşça aç
            led_color = thresholds.get("led_color", (128, 0, 128))  # Sunucudan veya varsayılan renk
            target_brightness = min(max(light / 1023, 0.1), 1.0)  # Parlaklık hedef değeri

            if light < thresholds["light_threshold"]:
                if not led_on:
                    start_fade_in(led_color, target_brightness)  # LED'leri yavaşça aç
                    led_on = True
                    print("LED şeridi açılıyor.")
            else:
                if led_on:
                    control_led((0, 0, 0), 0)  # LED'leri kapat
                    led_on = False
                    print("LED şeridi kapatıldı.")

            # Sensör verilerini belirli aralıklarla sunucuya gönderme
            if current_time - last_sensor_send > SENSOR_SEND_INTERVAL:
                send_sensor_data(sensor_data)
                last_sensor_send = current_time

            # Diğer sensör kontrolleri
            if pressure < thresholds["pressure_threshold"]:
                print("Basınç seviyesi düşük.")

        # LED parlaklık geçiş adımını güncelle
        fade_in_led_step()

        time.sleep(0.1)  # Program akışını hafifletmek için kısa bir gecikme

except KeyboardInterrupt:
    print("Program sonlandırıldı.")

finally:
    # GPIO pinleri temizle
    GPIO.cleanup()
    serial_conn.close()
