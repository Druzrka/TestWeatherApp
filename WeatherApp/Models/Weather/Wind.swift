//
//  Wind.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

struct Wind: Decodable {
    
    public var speed: Double?
    public var deg: Double?
    
    private enum CodingKeys: String, CodingKey {
        case speed, deg
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        speed         = try container.decodeIfPresent(Double.self, forKey: .speed)
        deg           = try container.decodeIfPresent(Double.self, forKey: .deg)
    }
}
