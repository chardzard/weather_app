//
//  WeatherLine.swift
//  weather
//
//  Created by Richard Sage on 2016-02-19.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import Foundation

class WeatherLine {
    
    // Attributes
    var url : String
    var city : String
    var province : String
    
    // Constructor
    init(url: String, city: String, province: String) {
        self.url = url
        self.city = city
        self.province = province
    }
}