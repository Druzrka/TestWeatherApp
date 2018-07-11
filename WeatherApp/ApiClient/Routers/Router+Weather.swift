//
//  Router+Weather.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherRouter: URLRequestConvertible {
    
    case getCityCurrentWeather(lat: Double, lon: Double)
    case getForecastForCity(lat: Double, lon: Double)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var url: String {
        switch self {
        case .getCityCurrentWeather(let lat, let lon):
            return "/data/2.5/weather?lat=\(lat)&lon=\(lon)"
            
        case .getForecastForCity(let lat, let lon):
            return "/v1/forecast.json?key=\(C.keys.apixuWeahterKey)&q=\(lat),\(lon)&days=5"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var url = String()
        
        switch self {
        case .getCityCurrentWeather:
            url = ApiClient.shared.openWeatherUrl + self.url + "&appid=\(C.keys.weatherApiKey)"
            
        case .getForecastForCity:
            url = ApiClient.shared.apixuWeatherUrl + self.url
        }
        
        var urlRequest = URLRequest(url: try url.asURL())
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
