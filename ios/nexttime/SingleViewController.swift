//
//  ViewController.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-06.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit
import MLPAutoCompleteTextField
import GoogleMaps

class SingleViewController: UIViewController, MLPAutoCompleteTextFieldDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var specifierField:MLPAutoCompleteTextField!
    @IBOutlet weak var reminderBodyView:UITextView!
    @IBOutlet weak var typeControl:UISegmentedControl!
    @IBOutlet weak var doneButton:UIBarButtonItem!
    
    var updateId:String?
    
    var selectedFriend:Friend?
    var selectedPlace:Place?
    
    let specifierPlaceholders = ["with": "Enter a friend's name (e.g. Bart)...", "near": "Enter the name of a place (e.g. Walmart)..."]
    
    var defaultSegment = "with"
    
    var defaultSpecifierText = ""
    var defaultReminderBodyText = ""
    
    @IBAction func didChangeType(sender:AnyObject) {
        specifierField?.text = ""
        if typeControl?.selectedSegmentIndex == 0 {
            specifierField?.placeholder = specifierPlaceholders["with"]
            specifierField?.autoCompleteDataSource = FriendsDataSource.sharedDataSource()
        } else {
            specifierField?.placeholder = specifierPlaceholders["near"]
            specifierField?.autoCompleteDataSource = PlacesDataSource.sharedDataSource()
        }
        specifierField?.autoCompleteDelegate = self
        specifierField?.delegate = self
        reminderBodyView?.delegate = self
        selectedFriend = nil
        selectedPlace = nil
        updateDoneButton()
    }
    
    override func viewDidLoad() {
        let defaultIndex = "with" == defaultSegment ? 0 : 1
        
        typeControl!.selectedSegmentIndex = defaultIndex
        let initPlace = selectedPlace
        didChangeType(typeControl!)
        selectedPlace = initPlace
        
        specifierField!.text = defaultSpecifierText
        reminderBodyView!.text = defaultReminderBodyText
        
        let reminderClient = ReminderClient()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if updateId != nil {
            print("UPDATE VIEW")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateDoneButton() {
        let isDone = (selectedFriend != nil || selectedPlace != nil) && reminderBodyView?.text != ""
        doneButton?.enabled = isDone
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, didSelectAutoCompleteString selectedString: String!, withAutoCompleteObject selectedObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) {
        if let friend = selectedObject as? Friend {
            selectedFriend = friend
        } else if let place = selectedObject as? Place {
            selectedPlace = place
        }
        updateDoneButton()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        selectedFriend = nil
        selectedPlace = nil
        updateDoneButton()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        updateDoneButton()
        return true
    }
    
    @IBAction func doCreate(sender:AnyObject) {
        print("Create")

        let newType = typeControl!.selectedSegmentIndex == 0 ? "with" : "near"
        let newSpecifier = specifierField!.text!
        let newReminderBody = reminderBodyView!.text
        
        if updateId == nil {
            ReminderClient.sharedClient().addReminder(Reminder(type: newType, specifier: newSpecifier, reminderBody: newReminderBody))
        } else {
            //TODO: Update reminder
            ReminderClient.sharedClient().updateReminder(updateId!, newType: newType, newSpecifier: newSpecifier, newReminderBody: newReminderBody)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

}

