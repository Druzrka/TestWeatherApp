//
//  WeatherMainBody.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

struct WeatherMainBody: Decodable {
    
    public var temperature: Double?
    public var minTemperature: Double?
    public var maxTemperature: Double?
    public var humidity: Int?
    
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case humidity
    }
    
    init(from decoder: Decoder) throws {
        
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        temperature       = try container.decodeIfPresent(Double.self, forKey: .temperature)
        minTemperature    = try container.decodeIfPresent(Double.self, forKey: .minTemperature)
        maxTemperature    = try container.decodeIfPresent(Double.self, forKey: .maxTemperature)
        humidity          = try container.decodeIfPresent(Int.self, forKey: .humidity)
    }
}
