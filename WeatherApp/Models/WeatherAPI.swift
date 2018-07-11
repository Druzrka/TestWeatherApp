//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Захар on 10.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

class WeatherAPI {
    
    private var cities: [City] = []
    private var numberOfSetWeahter: Int = 0
    
    public func getCitiesWithCurrentWeather(com: @escaping ([City]) -> Void) {
        
        cities = DatabaseManager().getCities()
        
        getWeatherForCities {
            com(self.cities)
        }
    }
    
    // API
    public func getWeatherByCoordinates(lat: Double, lon: Double, completion: @escaping () -> Void) {
        
        ApiClient.shared.getCityCurrentWeather(lat: lat, lon: lon) { (response, error) in
            if error != nil {
                p(error!)
                
            } else if let res = response as? Weather, let cityname = res.cityName {
                
                let city = City(name: cityname, country: "", lon: String(lon), lat: String(lat))
                DatabaseManager().saveCity(city)
                completion()
            }
        }
    }
    
    private func getWeatherForCities(completion: @escaping () -> Void) {
        
        cities.forEach { (city) in
            
            if city.weather == nil {
                U.BG {
                    self.getCityWeather(city: city) {
                        if self.numberOfSetWeahter == self.cities.count  {
                            self.numberOfSetWeahter = 0
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    private func getCityWeather(city: City, completion: @escaping () -> Void) {
        
        guard let lat = city.lat, let lon = city.lon else {
            return
        }
        
        ApiClient.shared.getCityCurrentWeather(lat: lat.double, lon: lon.double) { (response, error) in
            if error != nil {
                p(error!)
                
            } else if let weatherResponse = response as? Weather {
                city.weather = weatherResponse
                self.numberOfSetWeahter += 1
                completion()
            }
        }
    }
}
