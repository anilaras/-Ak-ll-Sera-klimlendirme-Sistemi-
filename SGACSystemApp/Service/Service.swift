//
//  Service.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 27.11.2024.
//

import Foundation

protocol ServiceProtocol {
    static func getSensorValue(completion: @escaping (Result<SensorValueModel, Error>) -> ())
    static func updateSensorValue(model: SensorValueModel, completion: @escaping (Result<PostReturnModel, Error>) -> ())
    static func getLedValue(completion: @escaping (Result<LedModel, Error>) -> ())
    static func updateLedValue(model: LedModel, completion: @escaping (Result<PostReturnModel, Error>) -> ())
}

struct Service: ServiceProtocol {
    static func getLedValue(completion: @escaping (Result<LedModel, any Error>) -> ()) {
        getRequest(target: .ledSettings, completion: completion)
    }
    
    static func updateLedValue(model: LedModel, completion: @escaping (Result<PostReturnModel, any Error>) -> ()) {
        postRequest(target: .ledSettings, model: model, completion: completion)
    }
    
    static func updateSensorValue(model: SensorValueModel, completion: @escaping (Result<PostReturnModel, any Error>) -> ()) {
        postRequest(target: .sensorValue, model: model, completion: completion)
    }
    
    static func getSensorValue(completion: @escaping (Result<SensorValueModel, any Error>) -> ()) {
        getRequest(target: .sensorValue, completion: completion)
    }
}

extension Service {
    private static func getRequest<T: Codable>(target: API, completion: @escaping (Result<T, Error>) -> ()) {
        var request = URLRequest(url: target.baseURL)
        request.addValue(target.token, forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private static func postRequest<R: Codable, T: Codable>(target: API, model: R, completion: @escaping (Result<T, Error>) -> ()) {
        var request = URLRequest(url: target.baseURL)
        request.addValue(target.token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        
        let jsonData = try! JSONEncoder().encode(model)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
