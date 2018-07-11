//
//  City.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation
import CoreData

class City: Decodable {
    
    var name: String?
    var country: String?
    var lon: String?
    var lat: String?
    var weather: Weather?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case country
        case lng
        case lat
    }
    
    init(data: NSManagedObject) {
        name    = data.value(forKey: "name") as? String
        country = data.value(forKey: "country") as? String
        lon     = data.value(forKey: "lon") as? String
        lat     = data.value(forKey: "lat") as? String
    }
    
    init(name: String?, country: String?, lon: String?, lat: String?) {
        
        self.name = name
        self.country = country
        self.lon = lon
        self.lat = lat
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name          = try container.decodeIfPresent(String.self, forKey: .name)
        country       = try container.decodeIfPresent(String.self, forKey: .country)
        lon           = try container.decodeIfPresent(String.self, forKey: .lng)
        lat           = try container.decodeIfPresent(String.self, forKey: .lat)
    }
}
