# API Endpoint'leri ve Kullanımları

## Sensör Verilerini Kaydetme
```
POST /api/v1/sensor-data

Header: Authorization: token

Body: {"rawgas":11,"correctedPPMgas":0.088671,"PPMgas":0.11963,"light":189,"soil_moisture":1022,"temperature":27.27,"humidity":26.52539,"pressure":878.3098}
```
## Sensör Verilerini Sorgulama
```
GET /api/v1/sensor-data?start_date=2024-01-01&end_date=2024-01-31

Header: Authorization: token
```
## Eşik Değerlerini Alma
```
GET /api/v1/thresholds

Header: Authorization: token
```

## Eşik Değerlerini Güncelleme

```
POST /api/v1/thresholds

Header: Authorization: token

Body: {

"soil_moisture": 30,

"light_level": 500,

"gas_level": 1000,

"air_pressure": 1013,

"temperature": 25,

"humidity": 60

}
```
## LED Ayarlarını Alma
```
GET /api/v1/led-settings

Header: Authorization: token
```
## LED Ayarlarını Güncelleme
```
POST /api/v1/led-settings

Header: Authorization: token

Body: {

"red": 128,

"green": 0,

"blue": 128,

"brightness": 100

}
```
