//
//  DatabaseManager.swift
//  WeatherApp
//
//  Created by Захар on 05.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation
import CoreData

class DatabaseManager {
    
    private var context: NSManagedObjectContext

    init() {
        context = U.appDelegate.persistentContainer.viewContext
        addDefaultCitiesIfNeeded()
    }
    
    private func save() {
        
        do {
            try context.save()
            
        } catch {
            p(error)
        }
    }
    
    public func saveCity(_ city: City) {
        
        guard !cityExist(city) else {
            return 
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Cities", in: context)
        let newCity = NSManagedObject(entity: entity!, insertInto: context)
        
        newCity.setValue(city.name, forKey: "name")
        newCity.setValue(city.country, forKey: "country")
        newCity.setValue(city.lat, forKey: "lat")
        newCity.setValue(city.lon, forKey: "lon")
        
        save()
    }
    
    public func deleteCity(_ selectedCity: City) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                let city = City(data: data)
                if city.name == selectedCity.name {
                    context.delete(data)
                }
            }
            
        } catch {
            
            p("Failed \(error)")
        }
        
        save()
    }
    
    public func getCities() -> [City] {
        
        var cities = [City]()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                cities.append(City(data: data))
            }
            
        } catch {
            
            p("Failed \(error)")
        }
        
        return cities
    }
    
    private func addDefaultCitiesIfNeeded() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cities")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let result = try context.fetch(request)
            if result.isEmpty {
                addDefaultCities()
            }
            
        } catch {
            
            p("Failed \(error)")
        }
    }
    
    private func addDefaultCities() {
        
        
        let defaultCities = [
            City(name: "Sant Julià de Lòria", country: "AD", lon: "42.46372", lat: "1.49129"),
            City(name: "Pas de la Casa", country: "AD", lon: "42.54277", lat: "1.73361")
        ]
        
        defaultCities.forEach { (city) in
            saveCity(city)
        }
    }
    
    private func cityExist(_ selectedCity: City) -> Bool {
        
        let cities = getCities()
        
        for city in cities {
            if selectedCity.name == city.name {
                return true
            }
        }
        return false
    }
}
