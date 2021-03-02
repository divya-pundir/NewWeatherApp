//
//  ApiRequest.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import Foundation

class ApiRequest<T: Codable> {
    let hostAddress: String
    let path: String
    let method: HTTPMethod
    let headerParameters: [String: String]?
    let queryParameters: [String: String]?
    let requestParameters: [String: Any?]?
    typealias completion = (T?, NetworkError?) -> Void
    
    init(host: String, path: String = "", method: HTTPMethod = .get, headerParameters: [String: String]? = nil, requestParameters: [String: Any?]? = nil, queryParameters: [String: String]? = nil) {
        self.hostAddress = host
        self.path = path
        self.method = method
        self.headerParameters = headerParameters
        self.requestParameters = requestParameters
        self.queryParameters = queryParameters
    }
    
    //Create Request using Request structure Parameters
    func buildRequest() -> URLRequest {
        var components = URLComponents(string: hostAddress)!
        components.path += path
        components.queryItems = queryParameters?.map({
            URLQueryItem(name: $0.key, value: $0.value)
        })
        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch method {
        case .get, .delete:
            components.queryItems = headerParameters?.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        case .post, .put:
            if let params = requestParameters {
                request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            }
            else {
                request.httpBody = nil
            }
        }
        return request
    }

    func execute(completion: @escaping completion) {
        if !Reachability.isConnectedToNetwork() {
            print("Not Connected to Internet")
            completion(nil, NetworkError.noInternet)
        }
        let request = self.buildRequest()
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error.debugDescription)
                completion(nil, NetworkError.unknownError(error: error!))
            }
            
            guard let res = response as? HTTPURLResponse else {
                print("API Response is Empty")
                return completion(nil, NetworkError.noResponse)
            }
            
            if res.statusCode >= 200 && res.statusCode < 300, let data = data {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    return completion(response, nil)
                } catch {
                    print(error.localizedDescription)
                    return completion(nil, NetworkError.unknownError(error: error))
                }
            } else {
                print("Api Failed")
                return completion(nil,NetworkError.requestRejected(reason: res.statusCode.description) )
            }
        }.resume()
    }
}

