//
//  ViewController.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-06.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {
    
    @IBOutlet weak var specifierField:UITextField?
    @IBOutlet weak var reminderBodyView:UITextView?
    
    let specifierPlaceholders = ["with": "Enter a friend's name (e.g. Bart)...", "near": "Enter the name of a place (e.g. Walmart)..."]

    @IBAction func didChangeType(sender:AnyObject) {
        let typeControl = sender as! UISegmentedControl
        if typeControl.selectedSegmentIndex == 0 {
            specifierField?.placeholder = specifierPlaceholders["with"]
        } else {
            specifierField?.placeholder = specifierPlaceholders["near"]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

