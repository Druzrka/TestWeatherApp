//
//  WeatherCondition.swift
//  WeatherApp
//
//  Created by Захар on 09.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

struct WeatherCondition: Decodable {
    
    public var condition: String?
    public var apixuCondition: String?
    public var description: String? {
        didSet {
            if condition == "clouds" {
                if description == "few clouds" {
                    condition = description
                }
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case condition = "main"
        case apixuCondition = "text"
        case description
    }
    
    init(from decoder: Decoder) throws {
        
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        condition      = try container.decodeIfPresent(String.self, forKey: .condition)
        description    = try container.decodeIfPresent(String.self, forKey: .description)
        apixuCondition = try container.decodeIfPresent(String.self, forKey: .apixuCondition)
        
        if apixuCondition?.contains("Sunny") == true {
            apixuCondition = "clear"
            
        } else if apixuCondition?.contains("cloudy") == true {
            apixuCondition = "clouds"
            
        } else if apixuCondition?.contains("rain") == true {
            apixuCondition = "rain"
        }
    }
}
