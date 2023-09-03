//
//  GoogleMapsRepository.swift
//
//  Created by Mohamed Elbana on 02/09/2023.
//  Copyright © 2023 Mohamed Elbana. All rights reserved.
//

import UIKit
import CoreApp
import CoreLocation

enum GMRResult<T,V> {
    case success(T)
    case failure(V)
}

class GoogleMapsRepository {
    
    /// Get distance between source and destination from Google Maps API
    ///
    /// - Parameters:
    ///   - source: The start CLLocationCoordinate2D
    ///   - destination: The end CLLocationCoordinate2D
    ///   - completion: GMRResult<String, String>
    ///
    static func getDistance(from source: CLLocationCoordinate2D,
                            to destination: CLLocationCoordinate2D,
                            _ completion: @escaping (GMRResult<String, String>) -> ()) {
        let origin = "\(source.latitude),\(source.longitude)"
        let target = "\(destination.latitude),\(destination.longitude)"
        
        var distance: String?
        var path = "https://maps.googleapis.com/maps/api/directions/json"
        path += "?origin=\(origin)"
        path += "&destination=\(target)"
        path += "&sensor=false"
        path += "&mode=\("DRIVING")"
        path += "&key=\(Constants.googleAPIKey)"
        
        guard let url = URL(string: path) else {
            return completion(.failure("Path not correct"))
        }
        
        let task = URLSession.shared.dataTask(
            with: url,
            completionHandler: { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure("Fail to cast"))
                    return
                }
                
                if let result = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any],
                   let routes = result["routes"] as? [[String:Any]],
                   let route = routes.first,
                   let legs = route["legs"] as? [[String:Any]],
                   let leg = legs.first,
                   let dist = leg["distance"] as? [String:Any],
                   let distanceText = dist["text"] as? String {
                    distance = distanceText
                }
                completion(.success(distance ?? ""))
            })
        task.resume()
    }
    
    /// Get time between source and destination from Google Maps API
    ///
    /// - Parameters:
    ///   - source: The start CLLocationCoordinate2D
    ///   - destination: The end CLLocationCoordinate2D
    ///   - completion: GMRResult<String, String>
    ///
    static func getTime(from source: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        _ completion: @escaping (GMRResult<String, String>) -> ()) {
        let origin = "\(source.latitude),\(source.longitude)"
        let target = "\(destination.latitude),\(destination.longitude)"
        
        var path = "https://maps.googleapis.com/maps/api/distancematrix/json"
        path += "?units=imperial"
        path += "&origins=\(origin)"
        path += "&destinations=\(target)"
        path += "&key=\(Constants.googleAPIKey)"
        
        guard let url = URL(string: path) else {
            return completion(.failure("Path not correct"))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                let apiData = try JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let dic = apiData as? [String:Any],
                      let rows = dic["rows"] as? [[String : Any]] else {
                    completion(.failure("Fail to cast"))
                    return
                }
                
                if dic["status"] as? String == "OK" {
                    guard let elements = rows.first?["elements"] as? [[String : Any]],
                          let duration = elements.first?["duration"] as? [String : Any],
                          let time = duration["text"] as? String else {
                        completion(.failure("Fail to cast"))
                        return
                    }
                    completion(.success(time))
                } else {
                    completion(.failure(dic["status"] as? String ?? ""))
                }
            } catch {
                completion(.failure(error.localizedDescription))
            }
        }
        task.resume()
    }
}
