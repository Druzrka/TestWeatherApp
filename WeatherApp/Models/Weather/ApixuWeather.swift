//
//  ApixuWeather.swift
//  WeatherApp
//
//  Created by Захар on 10.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

struct ApixuWeather: Decodable {
    
    public var temperature: Double?
    public var condition: WeatherCondition?
    public var humidity: Double?
    public var windSpeed: Double?
    
    private enum CodingKeys: String, CodingKey {
        case temp = "avgtemp_c"
        case humidity = "avghumidity"
        case condition
        case windSpeed = "maxwind_kph"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        temperature   = try container.decodeIfPresent(Double.self, forKey: .temp)
        humidity      = try container.decodeIfPresent(Double.self, forKey: .humidity)
        condition     = try container.decodeIfPresent(WeatherCondition.self, forKey: .condition)
        windSpeed     = try container.decodeIfPresent(Double.self, forKey: .windSpeed)
    }
}
