//
//  NetworkManager.swift
//  SCMP Staff List APP
//
//  Created by Anson Wong on 21/1/2024.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // Perform a GET request
    func getData(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NSError(domain: "Invalid response", code: 0, userInfo: nil)
                }
                return data
            }
            .mapError { error -> Error in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    // Perform a POST request
    func post(url: URL, parameters: [String: Any]) -> AnyPublisher<Data, Error> {
        let headers = [
            "Content-Type": "application/json"
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in data }
            .mapError { error -> Error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
