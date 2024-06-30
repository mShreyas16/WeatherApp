//
//  WeatherDetailsService.swift
//  WeatherApp
//
//  Created by Shreyas Mandhare on 29/06/24.
//

import Foundation


class WeatherDetailsService {
    
    
    typealias closure = (WeatherDetailsModel?) -> ()
    
    
    func getWeatherDetails(location: String, completion: @escaping (closure)) {
        
        
        var request = URLRequest(url: URL(string: "https://api.weatherapi.com/v1/current.json?key=d2e8daa15e854c66abc125354242806&q=\(location)&aqi=no%0A")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
              completion(nil)
            return
          }
            do {
                let modelData = try JSONDecoder().decode(WeatherDetailsModel.self, from: data)
                completion(modelData)
//                print(modelData, "modelData")
            } catch {
                print(error.localizedDescription)
            }
            
        }

        task.resume()
        
        
    }
    
}
