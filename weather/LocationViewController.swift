//
//  WeatherViewController.swift
//  weather
//
//  Created by Richard Sage on 2016-02-19.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Data being fed in from other views
    var feed : WeatherFeed?
    
    // Arrays for displaying text from feeds.csv
    var provinceNames : Array<String> = []
    var cityNames : Array<String> = []
    
    // Which province and city are selected
    var selectedProvince : Int = -1
    var selectedCity : Int = -1
    
    // Outlets
    @IBOutlet weak var province: UIPickerView!
    @IBOutlet weak var city: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        provinceNames = Array<String>()
        
        // If the feed doesn't exist yet or it wasn't loaded
        if(feed?.didLoad == nil || (feed?.didLoad) == false) {
            feed = WeatherFeed()
        }
        // Fills in the names of the provinces and cities for the picker views
        fillNames()
        
        // Set delegates and data sources
        province.dataSource = self
        province.delegate = self
        city.dataSource = self
        city.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Feed data back into the main view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? ViewController {
            dest.feed = feed
//            print(dest.city)
//            print(selectedCity)
            dest.city = selectedCity
            dest.province = selectedProvince
        }        
    }
    
    // Put province names into the picker view
    func fillNames() {
        for p in (feed?.provinces)! {
            provinceNames.append(p.name)
        }
        provinceNames.insert("", atIndex: 0)
    }
    
    // How many scroll wheels in each picker view. Just one in this case
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // How many items in each picker view
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0) {
            return provinceNames.count
        }
        else {
            return cityNames.count
        }
    }
    
    // Text that is displayed in each row of the picker view
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0) {
            return provinceNames[row]
        }
        else if(pickerView.tag == 1) {
            return cityNames[row]
        }
        else {
            return ""
        }
    }
    
    // Determine what happens when a row is selected
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // If the province has a new selection
        if(pickerView.tag == 0) {
            if(row > 0) {
                cityNames = []
                // Put the province city names into the next picker list
                for c in (feed?.provinces[row - 1].cities)! {
                   cityNames.append(c.name)
                }
                selectedProvince = row - 1
            }
            else {
                // Clear everything if blank province
                selectedProvince = -1
                selectedCity = -1
                cityNames = []
            }
            // Reload city picker view to get new names displaying
            city.reloadAllComponents()
        }
        else {
            selectedCity = row
        }
    }
    
    // This function modifies how each row looks in the picker views
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {
            pickerLabel = UILabel()
        }
        var titleData = ""
        if(pickerView.tag == 0) {
            titleData = provinceNames[row]
        }
        else {
            titleData = cityNames[row]
        }
        // This changes the font size and type for the displayed text
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 16)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        
        return pickerLabel
    }
}
