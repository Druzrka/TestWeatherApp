//
//  JSONReader.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Foundation

class JSONReader {
    
    public typealias ResponseCompletion = (_ answer: Any?) -> Void
    
    private func getData<T>(fileName: String, dataType: T.Type) -> Any? where T : (Decodable) {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let res = try JSONDecoder().decode(dataType, from: data)
                
                return res
                
            } catch {
                p(error.localizedDescription)
            }
        }
        
        return nil
    }
}

// MARK: JSONReader + City
extension JSONReader {
    
    public func getCities(completion: @escaping ((_ cities: [City]) -> Void)) {
        
        guard let cities = getData(fileName: "cities", dataType: [City].self) as? [City] else {
            return
        }
        
        completion(cities)
    }
}
