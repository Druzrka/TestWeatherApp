//
//  CityWeatherDetailsVC.swift
//  WeatherApp
//
//  Created by Захар on 09.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import UIKit

class CityWeatherDetailsVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var rainchanceLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    // MARK: Properties
    public var city: City?
    private var forecastDays: [ForecastDay] = []
    
    // MARK: View did load method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        U.BG { self.getForecastForCity() }
        setupUI()
    }
    
    // API Methods
    private func getForecastForCity() {
        
        guard let city = city, let lat = city.lat, let lon = city.lon else {
            return
        }
        
        ApiClient.shared.getForecastForCity(lat: lat.double, lon: lon.double) { (response, error) in
            if let res = response as? ForecastWeatherResponse, let forecast = res.forecast, let days = forecast.forecastDays {
                self.forecastDays = days
                U.UI { self.forecastCollectionView.reloadData() }
            } else if let err = error {
                p(err.description)
            }
        }
    }
    
    // UI Methods
    private func setupUI() {
        
        guard let city = city else {
            return
        }
        
        let layout = CitiesLayout()
        layout.numberOfColumns = 5
        layout.isSquare = false
        forecastCollectionView.collectionViewLayout = layout
        
        if let name = city.name {
            navigationItem.title = name
        }
        
        if let weatherCondition = city.weather?.condition?.condition {
            currentWeatherImage.image = UIImage(named: weatherCondition.lowercased() + "_Big")
            
            if currentWeatherImage.image == nil {
                currentWeatherImage.image = R.image.fewClouds_Big()
            }
        }
        
        if let temp = city.weather?.temperature {
           tempLabel.text = "\(temp.kelvinToCelsius) ℃"
        }
        
        if let windSpeed = city.weather?.wind?.speed {
            
            windSpeedLabel.text = String(format: "%.2f", windSpeed) + "m/s"
        }
        
        if let humidity = city.weather?.humidity {
            humidityLabel.text = "\(humidity)%"
        }
    }
    
    private func showDeleteAlert() {
        
        guard let city = city else {
            return
        }
        
        let deleteAction = UIAlertAction(title: R.string.localizable.delete(), style: .destructive) { _ in
            DatabaseManager().deleteCity(city)
            self.navigationController?.popViewController(animated: true)
        }
        
        U.showAlert(R.string.localizable.warning(), message: R.string.localizable.deleteText(), actions: [deleteAction])
    }
    
    private func weekday(for index: Int) -> String {
        
        let date = Calendar.current.date(byAdding: .day, value: index, to: Date())
        let dateFormatter = DateFormatter()
        let weekdayIndex = Calendar.current.component(.weekday, from: date!)
        
        let weekday = dateFormatter.weekdaySymbols[weekdayIndex - 1]
        
        return weekday
    }
    
    // MARK: IB actions
    @IBAction func deleteButtonPressed() {
        showDeleteAlert()
    }
}

// MARK: Collection view data source and delegate
extension CityWeatherDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.weatherCollectionViewCell, for: indexPath) {
            
            configureCell(cell, at: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    private func configureCell(_ cell: WeatherCollectionViewCell, at indexPath: IndexPath) {
        
        guard let weather = forecastDays[indexPath.row].weather else {
            return
        }
        
        if let temp = weather.temperature {
            cell.tempLabel.text = "\(Int(temp))" + C.signs.degree
        }
        
        if let condition = weather.condition?.apixuCondition {
            cell.weatherConditionImage.image = UIImage(named: condition)
            
            if cell.weatherConditionImage.image == nil {
                cell.weatherConditionImage.image = R.image.fewClouds_Big()
            }
        }
        
        cell.weekDayLabel.text = weekday(for: indexPath.row)
    }
}
