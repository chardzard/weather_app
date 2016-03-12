//
//  WeatherFeed.swift
//  weather
//
//  Created by Richard Sage on 2016-02-19.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import Foundation

class WeatherFeed {
    
    // Arrays to hold data from feeds.csv
    var csvFile : Array<WeatherLine>
    var provinces : Array<Province>
    
    // Bool to ensure the file loaded properly
    var didLoad : Bool = false
    
    init() {
        csvFile = Array<WeatherLine>()
        provinces = Array<Province>()
        didLoad = readCSV()
    }    
    
    // Read the feeds.csv file. Returns whether or not it succeeded
    func readCSV() -> Bool {
        // Load the file
        guard let path = NSBundle.mainBundle().pathForResource("feeds", ofType: "csv")
            else {return false}
        
        // Delimiter to separate each line by
        let delimiter = ", "
        
        do {
            // Read the file, then split it into an array delimited by new lines
            let content = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
            var count = 0
            // Iterate through each line of the file
            for line in lines {
                var values:[String] = []
                if (line != "") {
                    // Split the line by the delimiter
                    values = line.componentsSeparatedByString(delimiter)
                    // Separate the data into the appropriate places
                    let weather = WeatherLine(url: values[0], city: values[1], province: values[2])
                    // Test if the province is in the array yet
                    var found = false
                    for p in provinces {
                        if(p.name == weather.province) {
                            found = true
                            // Put the city into the array in the province
                            let city = City(name: weather.city, url: weather.url)
                            p.cities.append(city)
                        }
                    }
                    // Province was not in the array already
                    if(!found) {
                        let p = Province(name: weather.province)
                        provinces.append(p)
                        let city = City(name: weather.city, url: weather.url)
                        p.cities.append(city)
                    }
                    // Add the line information to the array
                    csvFile.append(weather)
                }
                count++
            }
        }
        catch _ as NSError{
            return false
        }
        return true
    }
}
