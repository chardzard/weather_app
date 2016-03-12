//
//  DetailsViewController.swift
//  weather
//
//  Created by Richard Sage on 2016-02-19.
//  Copyright © 2016 Richard Sage. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var summaryView: UITextView!
    
    // Variables being fed in
    var index : Int = -1
    var weather : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySummary()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Display the text in the text view
    func displaySummary() {
        // Only attempt if a valid row number is sent
        if(index > -1) {
            let summary = weather.objectAtIndex(index).valueForKey("summary") as? String
            do {
                // Create an attributed string to handle the HTML tags in some summaries
                let str = try NSAttributedString(data: summary!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                summaryView.attributedText = str
            } catch {
                summaryView.text = summary
            }
        }
    }
}
