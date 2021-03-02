//
//  NetworkConstants.swift
//  NewWeatherApp
//
//  Created by Divya Pundir on 3/2/21.
//  Copyright © 2021 Divya Pundir. All rights reserved.
//

import Foundation


enum HTTPMethod: String {
    case get, put, post, delete
}

enum NetworkError: Error {
    case noInternet
    case decodingFailed
    case invalidURL
    case noData
    case noResponse
    case requestRejected(reason: String)
    case unknownError(error: Error)
    
    var localizedDescription: String {
        switch self {
        case .noInternet: return "No Internet"
        case .decodingFailed: return "Failed to decode data"
        case .invalidURL: return "Invalid endpoint"
        case .noData: return "No data"
        case .noResponse: return "No Api response"
        case .unknownError(let error): return error.localizedDescription
        case .requestRejected(let reason): return reason
        }
    }
}

