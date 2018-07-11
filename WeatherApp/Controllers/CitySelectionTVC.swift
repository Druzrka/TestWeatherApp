//
//  CitySelectionTVC.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import UIKit

class CitySelectionTVC: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var searchBar: DefaultSearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var typingTimer: Timer?
    
    private var cities: [City] = []
    private var citySections: [String] = []
    private var citiesDict = [String: [City]]() {
        didSet {
            citiesManager.setValues(self.citiesDict)
        }
    }
    private var citiesManager = CitiesManager()
    
    private var filteredCities: [City] = []
    private var isSearching: Bool = false
    
    private let cache = NSCache<NSString, CitiesManager>()

    // MARK: View did load method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.isUserInteractionEnabled = false
        searchBar.defaultSearchBarDelegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        activityIndicator(isActive: true)
        getCities()
    }
    
    private func getCities() {
        
        citiesManager.getValues { (citiesDict, cities) in
            
            self.citiesDict = citiesDict
            self.cities = cities
            self.citySections = [String](citiesDict.keys)
            self.citySections.sort()
            
            U.UI {
                self.activityIndicator(isActive: false)
                self.searchBar.isUserInteractionEnabled = true
                self.tableView.reloadData()
            }
        }
    }
    
    // UI Methods
    private func getHeaderView(title: String) -> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: U.screen.width, height: 30))
        
        headerView.backgroundColor = UIColor(red: 0.12, green:0.14, blue: 0.15, alpha: 1.0)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        label.backgroundColor = UIColor(red:0.12, green:0.14, blue:0.15, alpha:1.0)
        label.font = R.font.sfProTextSemibold(size: 17)
        label.textColor = .white
        label.text = title
        headerView.addSubview(label)
        
        return headerView
    }
    
    private func activityIndicator(isActive: Bool) {
        
        if isActive {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
        } else {
            self.activityIndicator.isHidden = true
            self.activityIndicator.startAnimating()
        }
    }
}

// MARK: Table view delegate and data source
extension CitySelectionTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        }
        return citySections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cityKey = citySections[section]
        
        if isSearching {
            return filteredCities.count
            
        } else if let cityValues = citiesDict[cityKey] {
            return cityValues.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        
        let cityKey = citySections[indexPath.section]
        
        if isSearching {
            cell.textLabel?.text = filteredCities[indexPath.row].name
            
        } else if let citValues = citiesDict[cityKey] {
            cell.textLabel?.text = citValues[indexPath.row].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let databaseManager = DatabaseManager()
        let cityKey = citySections[indexPath.section]
        
        if let cities = citiesDict[cityKey] {
            
            let city = cities[indexPath.row]
            databaseManager.saveCity(city)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerViewHeight: CGFloat = 30
        return isSearching ? 0 : headerViewHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isSearching {
            return nil
        }
        
        return getHeaderView(title: citySections[section])
    }
}

// MARK: DefaultSearchBarDelegate
extension CitySelectionTVC: DefaultSearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        typingTimer?.invalidate()
        typingTimer = nil
        typingTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(typingEnded), userInfo: nil, repeats: false)
    }
    
    @objc private func typingEnded() {
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            
            isSearching = true
            
            filteredCities = cities.filter({ (city) -> Bool in
                if let name = city.name {
                    return name.contains(searchText)
                }
                return false
            })
            
            
        } else {
            isSearching = false
        }
        
        tableView.reloadData()
    }
}
