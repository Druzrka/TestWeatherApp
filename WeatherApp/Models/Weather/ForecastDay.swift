//
//  ForecastDay.swift
//  WeatherApp
//
//  Created by Захар on 10.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

struct ForecastDay: Decodable {
    
    public var weather: ApixuWeather?
    
    private enum CodingKeys: String, CodingKey {
        
        case weather = "day"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        weather       = try container.decodeIfPresent(ApixuWeather.self, forKey: .weather)
    }
}
