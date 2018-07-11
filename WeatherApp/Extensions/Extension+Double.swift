//
//  Extension+Double.swift
//  WeatherApp
//
//  Created by Захар on 09.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

extension Double {
    
    var kelvinToCelsius: Int {
        return Int(self - 273)
    }
    
    var kmToMetersPerSecond: Int {
        return Int(self * 1000 / 3600)
    }
}
