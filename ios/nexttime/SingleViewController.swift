//
//  ViewController.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-06.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit
import MLPAutoCompleteTextField

class SingleViewController: UIViewController {
    
    @IBOutlet weak var specifierField:MLPAutoCompleteTextField?
    @IBOutlet weak var reminderBodyView:UITextView?
    @IBOutlet weak var typeControl:UISegmentedControl?
    
    let specifierPlaceholders = ["with": "Enter a friend's name (e.g. Bart)...", "near": "Enter the name of a place (e.g. Walmart)..."]
    
    let defaultSegment = "with"
    
    @IBAction func didChangeType(sender:AnyObject) {
        if typeControl?.selectedSegmentIndex == 0 {
            specifierField?.placeholder = specifierPlaceholders["with"]
            specifierField?.autoCompleteDataSource = FriendsDataSource.sharedDataSource()
        } else {
            specifierField?.placeholder = specifierPlaceholders["near"]
            specifierField?.autoCompleteDataSource = PlacesDataSource.sharedDataSource()
        }
    }
    
    override func viewDidLoad() {
        let defaultIndex = "with" == defaultSegment ? 0 : 1
        
        typeControl?.selectedSegmentIndex = defaultIndex
        if typeControl != nil {
            didChangeType(typeControl!)
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

