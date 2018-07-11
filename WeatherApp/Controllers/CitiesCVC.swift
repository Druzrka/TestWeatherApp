//
//  CitiesCVC.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import UIKit
import CoreLocation

class CitiesCVC: UICollectionViewController, CLLocationManagerDelegate {
    
    // Properties
    private var cities: [City] = []
    private let weatherApi = WeatherAPI()
    private var locationManger = LocationManager()
    
    // properties for collection view layout
    private let inset: CGFloat = 5
    private let spacing: CGFloat = 5
    private let lineSpacing: CGFloat = 2
    
    // MARK: View Will Appear method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCitisWithWeather()
    }
    
    private func getCitisWithWeather() {
        
        weatherApi.getCitiesWithCurrentWeather { cities in
            self.cities = cities
            self.collectionView?.reloadData()
        }
    }
    
    private func coordinatesWasSet(coordinates: CLLocationCoordinate2D) {
        
        weatherApi.getWeatherByCoordinates(lat: coordinates.latitude, lon: coordinates.longitude) {
            self.getCitisWithWeather()
        }
        locationManger.stopUpdatingLocation()
    }
    
    @IBAction func geoLocationButtonPressed() {
        
        locationManger.startUpdatingLocation()
        locationManger.currentLocationWasSet = coordinatesWasSet
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeatherDetailsVC" {
            if let weatherDetailsVC = segue.destination as? CityWeatherDetailsVC {
                weatherDetailsVC.city = sender as? City
            }
        }
    }
}

// MARK: Collection view delegate and data source
extension CitiesCVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.cityWeatherCell.identifier, for: indexPath) as! CityWeatherCell
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showWeatherDetailsVC", sender: cities[indexPath.row])
    }
    
    // Cell configuration
    private func configureCell(_ cell: CityWeatherCell, at indexPath: IndexPath) {
        
        let city = cities[indexPath.row]
        
        cell.cityNameLabel.text = city.name
        
        if let condition = city.weather?.condition?.condition?.lowercased() {
            cell.weatherImage.image = UIImage(named: U.isIpad ? condition + "_Big" : condition)
            
            if cell.weatherImage.image == nil {
                cell.weatherImage.image = U.isIpad ? R.image.fewClouds_Big() : R.image.fewClouds()
            }
        }
        
        if let maxTemp = city.weather?.maxTemperature?.kelvinToCelsius,
            let minTemp = city.weather?.minTemperature?.kelvinToCelsius {
            
            cell.weatherLabel.text = "\(maxTemp)/ \(minTemp) " + C.signs.celcius
        }
    }
}
