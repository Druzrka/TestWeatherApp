//
//  Weather.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    
    public var condition: WeatherCondition?
    public var minTemperature: Double?
    public var maxTemperature: Double?
    public var temperature: Double?
    public var wind: Wind?
    public var humidity: Int?
    public var cityName: String?
    
    private enum CodingKeys: String, CodingKey {
        case main, wind
        case condition = "weather"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case temp = "temp"
        case cityName = "name"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        condition     = try container.decodeIfPresent([WeatherCondition].self, forKey: .condition)?.last
        wind          = try container.decodeIfPresent(Wind.self, forKey: .wind)
        cityName      = try container.decodeIfPresent(String.self, forKey: .cityName)
        
        let weatherMainBody = try container.decodeIfPresent(WeatherMainBody.self, forKey: .main)
        temperature = weatherMainBody?.temperature
        minTemperature = weatherMainBody?.minTemperature
        maxTemperature = weatherMainBody?.maxTemperature
        humidity = weatherMainBody?.humidity
    }
}
