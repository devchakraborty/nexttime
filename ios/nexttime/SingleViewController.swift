//
//  ViewController.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-06.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {
    
    @IBOutlet weak var typeControl:UISegmentedControl?
    @IBOutlet weak var specifierField:UITextField?
    @IBOutlet weak var reminderBodyView:UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

