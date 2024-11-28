//
//  PastValueModel.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 28.11.2024.
//

import Foundation

struct PastValueModel: Codable, Hashable {
    let id: Int
    let rawGas: Int
    let correctedPpmGas: Int
    let light: Int
    let soilMoisture: Int
    let temperature: Int
    let humidity: Int
    let pressure: Int
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case rawGas = "raw_gas"
        case correctedPpmGas = "corrected_ppm_gas"
        case light
        case soilMoisture = "soil_moisture"
        case temperature
        case humidity
        case pressure
        case createdAt = "created_at"
    }
}
