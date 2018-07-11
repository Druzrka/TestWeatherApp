//
//  CitiesManager.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

class CitiesManager {
    
    private enum CacheKeys: NSString {
        case citiesDictKey = "CitiesDict"
    }
    
    private var citiesDict = [String: [City]]()
    private var cache: NSCache<NSString, CitiesManager>?
    
    public var cities = [City]()
    
    typealias CitiesCompletion = (([String: [City]], [City]) -> Void)
    
    init() {
        cache = U.appDelegate.cache
    }
    
    public func setValues(_ values: [String: [City]]) {
        citiesDict = values
    }
    
    func getValues(completion: @escaping CitiesCompletion) {
        U.BG {
            self.getCities()
            completion(self.citiesDict, self.cities)
        }
    }
    
    private func getCities() {
        
        if let cities = cache?.object(forKey: CacheKeys.citiesDictKey.rawValue){
            self.citiesDict = cities.citiesDict
            self.cities = cities.cities
            
            
        } else {
            getCitiesFromJSON()
            cacheCitiesDict()
        }
    }
    
    private func getCitiesFromJSON() {
        
        JSONReader().getCities(completion: { (cities) in
            
            self.cities = cities
            self.generateCitiesDict()
        })
    }
    
    private func generateCitiesDict() {
        
        cities.forEach { (city) in
            
            if let firstCharacter = city.name?.first, String(firstCharacter).isAlphanumeric {
                
                let key = "\(city.name?.first ?? Character(" "))"
                
                if var cityValues = citiesDict[key] {
                    cityValues.append(city)
                    citiesDict[key] = cityValues
                    
                } else {
                    citiesDict[key] = [city]
                }
            }
        }
    }
    
    private func cacheCitiesDict() {
        cache?.setObject(self, forKey: CacheKeys.citiesDictKey.rawValue)
    }
}
