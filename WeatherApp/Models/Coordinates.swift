//
//  Coordinates.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

class Coordinates: Decodable {
    
    var lon: Double?
    var lat: Double?
    
    private enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lon           = try container.decodeIfPresent(Double.self, forKey: .lon)
        lat           = try container.decodeIfPresent(Double.self, forKey: .lat)
    }
}
