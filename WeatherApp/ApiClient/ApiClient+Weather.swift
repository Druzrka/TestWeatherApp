//
//  ApiClient+Weather.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

extension ApiClient {
    
    public func getCityCurrentWeather(lat: Double, lon: Double, completion: @escaping RequestCompletion) {
        
        let getCityCurrentWeatherURL = WeatherRouter.getCityCurrentWeather(lat: lat, lon: lon)
        request(url: getCityCurrentWeatherURL, responseType: Weather.self) { (response, error) in
            completion(response, error)
        }
    }
    
    public func getForecastForCity(lat: Double, lon: Double, completion: @escaping RequestCompletion) {
        
        let getForecastForCityURL = WeatherRouter.getForecastForCity(lat: lat, lon: lon)
        request(url: getForecastForCityURL, responseType: ForecastWeatherResponse.self) { (response, error) in
            completion(response, error)
        }
    }
}
