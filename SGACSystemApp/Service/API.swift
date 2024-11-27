//
//  API.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 27.11.2024.
//

import Foundation

enum API {
    case sensorValue
    case ledSettings
}

extension API {
    
    var path: String {
        switch self {
        case .sensorValue:
            return "/api/v1/thresholds"
        case .ledSettings:
            return "/api/v1/led-settings"
        }
    }
    
    var token: String {
        return "cokgizli"
    }
    
    var baseURL: URL {
        let baseURL = "http://yesilarge.online\(path)"
        let encodedUrlString = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        guard let url = URL(string: encodedUrlString) else { fatalError() }
        return url
    }
}
