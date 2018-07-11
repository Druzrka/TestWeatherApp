//
//  ForecastWeatherResponse.swift
//  WeatherApp
//
//  Created by Захар on 10.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

class ForecastWeatherResponse: Response {
    
    public var forecast: WeatherForecast?
    
    private enum CodingKeys: String, CodingKey {
        case forecast
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        forecast = try container.decodeIfPresent(WeatherForecast.self, forKey: .forecast)
    }
}

