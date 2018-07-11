//
//  ApiClient.swift
//  WeatherApp
//
//  Created by Захар on 04.07.2018.
//  Copyright © 2018 Захар. All rights reserved.
//

import Alamofire
import Foundation

final class ApiClient {
    
    static let shared = ApiClient()
    
    let openWeatherUrl: String = "https://api.openweathermap.org"
    let apixuWeatherUrl: String = "https://api.apixu.com"
    
    public typealias RequestCompletion = (_ answer: Any?, _ error: Errors?) -> Void
    
    private let onMainQueue: (_ answer: Any?, _ error: Errors?, _ completion: @escaping RequestCompletion) -> Void = { response, error, completion in
        DispatchQueue.main.async {
            completion(response, error)
        }
    }
    
    // background thread
    func BG(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }

    // default request with params
    public func request<T>(url: URLRequestConvertible, responseType: T.Type, completion: @escaping RequestCompletion) where T : Response {
        if isConnectedToNetwork() {
            
            // send request
            Alamofire.request(url).response { response in
                self.handleResponse(response, responseType: responseType, completion: completion)
            }
        }
    }
    
    // request for responses withoutkeys
    public func request<T>(url: URLRequestConvertible, responseType: T.Type, completion: @escaping RequestCompletion) where T : Decodable {
        if isConnectedToNetwork() {
            // send request
            Alamofire.request(url).response { response in
                guard let data = response.data else {
                    self.onMainQueue(nil, .serverError, completion)
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(responseType, from: data)
                    self.onMainQueue(response, nil, completion)
                } catch {
                    self.onMainQueue(nil, .objectSerialization("Couldn't parse JSON: \(error)"), completion)
                }
                }.responseString(completionHandler: { response in
                    p(response)
                })
        }
    }
    
    private func handleResponse<T>(_ response: DefaultDataResponse, responseType: T.Type, completion: @escaping RequestCompletion) where T : Response {
        guard let data = response.data else {
            onMainQueue(nil, .serverError, completion)
            return
        }
        //        print(String(data: data, encoding: .utf8))
        do {
            let response = try JSONDecoder().decode(responseType, from: data)
            if let error = response.error {
                self.onMainQueue(nil, .custom(error), completion)
            } else if let errors = response.errors {
                let error = errors.joined(separator: "\n")
                self.onMainQueue(nil, .custom(error), completion)
            } else {
                self.onMainQueue(response, nil, completion)
            }
        } catch {
            self.onMainQueue(nil, .objectSerialization("Couldn't parse JSON: \(error)"), completion)
        }
    }
}


extension Dictionary {
    var urlParams: String {
        return self.getUrlParams(includeQuestionMark: true)
    }
    
    func getUrlParams(includeQuestionMark: Bool) -> String {
        var result = includeQuestionMark ? "?" : ""
        for (key, value) in self {
            result += "\(key)=\(value)&"
        }
        return result
    }
}
