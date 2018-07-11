//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Захар on 10.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    public var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    public var currentLocationWasSet: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         
        guard let location = manager.location else { return }
        
        currentLocation = location
        currentLocationWasSet?(location.coordinate)
    }
}
