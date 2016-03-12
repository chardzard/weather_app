//
//  Province.swift
//  weather
//
//  Created by Richard Sage on 2016-02-20.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import Foundation

class Province {
    
    // Attributes
    var name : String
    var cities : Array<City>
    
    // Constructor
    init(name: String) {
        self.name = name
        cities = Array<City>()
    }
}