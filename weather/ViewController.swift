//
//  ViewController.swift
//  weather
//
//  Created by Richard Sage on 2016-02-19.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var forecastView: UITableView!
    @IBOutlet weak var currentWeather: UILabel!
    
    // Information fed from other views
    var feed : WeatherFeed?
    var province : Int = -1
    var city : Int = -1
    
    // XML Parsing variables
    var elements = NSMutableDictionary()
    var tag = NSString()
    var xmlParser = NSXMLParser()
    var weather = NSMutableArray()
    var weatherTitle = NSMutableString()
    var weatherSummary = NSMutableString()
    
    // Selected row in the table view for the details view
    var rowSelected : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the back button so segues can't infinitely back
        self.navigationItem.hidesBackButton = true
        
        // If the province and city have been set by the location view
        if((province > -1 && city > -1)) {
            currentWeather.text = "Weather for " + (feed?.provinces[province].cities[city].name)! + ", " + (feed?.provinces[province].name)!
            beginParsing()
        }
        forecastView.delegate = self
        forecastView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // This function sends data to the other views as necessary
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // If the next view is for picking a new location
        if let dest = segue.destinationViewController as? LocationViewController {
            dest.feed = feed
        }
        // If the next view is for showing the summary details for a forecast / current conditions
        else if let dest = segue.destinationViewController as? DetailsViewController{
            dest.weather = weather
            dest.index = rowSelected
        }
    }
    
    // This function starts the XML parsing process
    func beginParsing()
    {
        weather = []
        
        // This pulls the XML from the RSS url of the selected city
        xmlParser = NSXMLParser(contentsOfURL:(NSURL(string: (feed?.provinces[province].cities[city].url)!))!)!
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    // Delegate function for starting the parsing of an XML file
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        tag = elementName

        // Only look at <entry> tags
        if (elementName as NSString).isEqualToString("entry")
        {
            elements = NSMutableDictionary()
            elements = [:]
            weatherTitle = NSMutableString()
            weatherTitle = ""
            weatherSummary = NSMutableString()
            weatherSummary = ""
        }
    }
    
    // Delegate function for when the parser finds characters in a tag
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if tag.isEqualToString("title") {
            weatherTitle.appendString(string)
        }
        if tag.isEqualToString("summary") {
            weatherSummary.appendString(string)
        }
    }
    
    // Delegate function for when an XML element is finished
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqualToString("entry") {
            if !weatherTitle.isEqual(nil) {
                elements.setObject(weatherTitle, forKey: "title")
            }
            if !weatherSummary.isEqual(nil) {
                elements.setObject(weatherSummary, forKey: "summary")
            }
            
            // Add the dictionary to the array
            weather.addObject(elements)
        }
    }
    
    // Sets the number of sections in the table. This will always be 1 for this app
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Sets the number of rows. This will be equal to the number of elements in the weather array
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return weather.count
    }
    
    // Callback for creating the cells for the table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as UITableViewCell!
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier: "CELL")
        }
        
        // Change the cell font size when the text would leave the cell
        cell.textLabel!.adjustsFontSizeToFitWidth = true
        cell.textLabel!.minimumScaleFactor = 0.1
        cell.textLabel!.font = UIFont.systemFontOfSize(10.0)
        
        // Set the text to the string in the title element of the entry tag
        cell.textLabel!.text = weather.objectAtIndex(indexPath.row).valueForKey("title") as? String
        
        return cell as UITableViewCell
    }
    
    // Delegate function for the table to trigger segue to the details view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Set global variable with the selected row so the prepare for segue function can send the row number
        rowSelected = indexPath.row
        // Trigger the segue
        self.performSegueWithIdentifier("forecastSegue", sender: self)
    }
}

