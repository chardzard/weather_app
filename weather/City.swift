//
//  City.swift
//  weather
//
//  Created by Richard Sage on 2016-02-20.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import Foundation

class City {
    
    // Attributes
    var name : String
    var url : String
    
    // Constructor
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }    
}