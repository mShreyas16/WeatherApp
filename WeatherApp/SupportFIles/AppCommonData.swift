//
//  AppCommonData.swift
//  WeatherApp
//
//  Created by Shreyas Mandhare on 29/06/24.
//

import Foundation
import UIKit


class AppCommonData : NSObject {
    
    static let sharedInstance = AppCommonData()
    
    override init() {
        super.init()
    }
    
    let bordercolor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0).cgColor
}
