//
//  WeatherForecast.swift
//  WeatherApp
//
//  Created by Захар on 10.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

struct WeatherForecast: Decodable {
    
    public var forecastDays: [ForecastDay]?
    
    private enum CodingKeys: String, CodingKey {
        case forecastDays = "forecastday"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        forecastDays  = try container.decodeIfPresent([ForecastDay].self, forKey: .forecastDays)
    }
}
