//
//  Errors.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation
//
enum Errors: Error {
    case custom(String)
    case objectSerialization(String)
    
    case serverError

    var description: String {
        switch self {
        case .custom(let error):
            return error
        case .objectSerialization(let reason):
            return reason

        case .serverError:
            return R.string.localizable.serverError()
        }
    }
}
