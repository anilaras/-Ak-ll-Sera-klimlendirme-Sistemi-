//
//  SensorValueModel.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 27.11.2024.
//

import Foundation

struct SensorValueModel: Codable, Hashable {
    let id: Int
    var soilMoisture: Double
    var lightLevel: Double
    var gasLevel: Double
    var airPressure: Double
    var temperature: Double
    var humidity: Double
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case soilMoisture = "soil_moisture"
        case lightLevel = "light_level"
        case gasLevel = "gas_level"
        case airPressure = "air_pressure"
        case temperature = "temperature"
        case humidity = "humidity"
        case updatedAt = "updated_at"
    }
}
 
