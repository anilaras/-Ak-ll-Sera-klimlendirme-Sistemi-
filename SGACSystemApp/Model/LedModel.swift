//
//  LedModel.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 27.11.2024.
//

import Foundation

struct LedModel: Codable {
    let id: Int
    var red: Double
    var green: Double
    var blue: Double
    var brightness: Double
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case red = "red"
        case green = "green"
        case blue = "blue"
        case brightness = "brightness"
        case updatedAt = "updated_at"
    }
}
