#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
#include <ArduinoJson.h>
#include <MQ135.h>

#define PIN_MQ135 A7
#define PIN_LDR A6
#define PIN_SOIL_MOISTURE A1
#define BME280_I2C_ADDR 0x76

Adafruit_BME280 bme;
MQ135 mq135_sensor(PIN_MQ135);
const size_t jsonBufferSize = JSON_OBJECT_SIZE(7);

int inverseMapping(int value) {
    if (value < 0 || value > 1024) {
        return -1;
    }
    return 1024 - value;
}

void setup() {
  Serial.begin(115200);
  if (!bme.begin(BME280_I2C_ADDR)) {
    Serial.println("BME280 başlatılamadı, bağlantıyı kontrol edin.");
    while (1);
  }
  delay(1000); 
}

void loop() {
  int ldrValue = analogRead(PIN_LDR);
  int soilMoistureValue = inverseMapping(analogRead(PIN_SOIL_MOISTURE));
  int mq135Value = analogRead(PIN_MQ135);

  int temperature = bme.readTemperature();
  int humidity = bme.readHumidity();
  int pressure = bme.readPressure() / 100.0F;
  
  float rzero = mq135_sensor.getRZero();
  float correctedRZero = mq135_sensor.getCorrectedRZero(temperature, humidity);
  float resistance = mq135_sensor.getResistance();
  int ppm = mq135_sensor.getPPM();
  int correctedPPM = mq135_sensor.getCorrectedPPM(temperature, humidity);
  
  StaticJsonDocument<jsonBufferSize> jsonDoc;
  jsonDoc["rawgas"] = mq135Value;
  jsonDoc["correctedPPMgas"] = correctedPPM;
  jsonDoc["PPMgas"] = ppm;
  jsonDoc["light"] = ldrValue;
  jsonDoc["soil_moisture"] = soilMoistureValue;
  jsonDoc["temperature"] = temperature;
  jsonDoc["humidity"] = humidity;
  jsonDoc["pressure"] = pressure;
  
  serializeJson(jsonDoc, Serial);
  Serial.println();
  
  delay(1000);
}
