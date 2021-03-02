//
//  NetworkManager.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    case Unknown
    case FailedRequest
    case InvalidResponse
}

class NetworkManager {
    
    fileprivate let apiKey = "7a9778c40068c1eec02be84eeea3f57d"
    typealias WeatherDataCompletion = (WeatherData?, DataManagerError?) -> ()
    static let shared = NetworkManager()
    
    func getURL(_ cityName : String) -> URL? {
         return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)")
    }
    
    // MARK: - Requesting Data
    func weatherDataForLocation(cityName: String, completion: @escaping WeatherDataCompletion) {
        if let url = getURL(cityName) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let _ = error {
                    completion(nil, .FailedRequest)

                } else if let data = data, let response = response as? HTTPURLResponse {
                     if response.statusCode == 200 {
                        self.processWeatherData(data: data, completion: completion)
                } else {
                    completion(nil, .FailedRequest)
                }

                } else {
                    completion(nil, .Unknown)
                }
            }.resume()
        }
    }
    
    private func processWeatherData(data: Data, completion: WeatherDataCompletion) {
//        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject {
//            completion(JSON, nil)
//        } else {
//            completion(nil, .InvalidResponse)
//        }
        
        
        if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
            completion(weatherData, nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
}
