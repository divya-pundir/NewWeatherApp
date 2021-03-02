//
//  WeatherService.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeatherDataFromServer(city: String, completion: @escaping (WeatherData?, NetworkError?) -> Void)
}

class WeatherService: WeatherServiceProtocol {

    func fetchWeatherDataFromServer(city: String, completion: @escaping (WeatherData?, NetworkError?) -> Void){
    let query = [cityName: city, apiKey: WeatherApiConstants.key.rawValue]
        let request = ApiRequest<WeatherData>(host: WeatherApiConstants.baseURL.rawValue,queryParameters: query)
        request.execute(completion: {(response,error)in
            if let response = response {
                print(response)
            } else {
                print(error ?? "")
            }
            completion(response,error)
        })
   
    }
}
