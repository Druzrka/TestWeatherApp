//
//  Response.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

protocol ResponseProtocol: Decodable {
    var error: String? {get}
    var errors: [String]? {get}
}

class Response: ResponseProtocol {
    
    var error: String?
    var errors: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case error
        case errors
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = try container.decodeIfPresent(String.self, forKey: .error)
        errors = try container.decodeIfPresent([String].self, forKey: .errors)
    }
}
