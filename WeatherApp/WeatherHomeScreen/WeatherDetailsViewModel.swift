//
//  WeatherDetailsViewModel.swift
//  WeatherApp
//
//  Created by Shreyas Mandhare on 29/06/24.
//

import Foundation

enum Response {
    case success
    case failure
    case inprogress
}

class WeatherDetailsViewModel {
    
    
    var weatherDetailsModel : WeatherDetailsModel?
    var getDataClosure : (Response) -> () = {response in }
    
    
    func getWeatherData(location:String) {
        
        WeatherDetailsService().getWeatherDetails(location: location) { [weak self] weatherDetModel in
            if weatherDetModel != nil {
                self?.weatherDetailsModel = weatherDetModel
                self?.getDataClosure(Response.success)
                
            } else {
                
                self?.getDataClosure(Response.failure)
                
            }
        }
        
    }
    
    
}
