//
//  ReminderClient.swift
//  nexttime
//
//  Created by Arkady Arkhangorodsky on 2015-11-07.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit
import CoreLocation

class ReminderClient: NSObject, CLLocationManagerDelegate{
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("reminders")
    
    static let shared = ReminderClient()
    
    var nearClient: NearClient
    var withClient: WithClient
    var locationManager: CLLocationManager?
    
    override init() {
        nearClient = NearClient()
        withClient = WithClient()
        
        super.init()
        locationManager = initLocationManager()
        locationManager!.startUpdatingLocation()
        let reminders = NSKeyedUnarchiver.unarchiveObjectWithFile(ReminderClient.ArchiveURL.path!) as? [Reminder] ?? []
        for reminder in reminders {
            addReminder(reminder)
        }
    }
    
    func initLocationManager()->CLLocationManager{
        let newLocationManager = CLLocationManager()
        let authStatus = CLLocationManager.authorizationStatus()
        
        if(authStatus == CLAuthorizationStatus.NotDetermined){
            newLocationManager.requestAlwaysAuthorization()
        }
        newLocationManager.delegate = self
        
        return newLocationManager
    }
    
    static func sharedClient()->ReminderClient {
        return shared
    }
    
    // MARK: Delegate functions
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations[locations.count-1]
        nearClient.checkReminders(latestLocation, onReminderTriggered : self.onReminderTriggered)
    }
    
    @objc func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        manager.stopUpdatingLocation()
        manager.startUpdatingLocation()
    }
    
    // MARK: Reminder managing functions
    
    func onReminderTriggered(reminder: Reminder) {
        print(reminder.reminderBody)
    }
    
    func addReminder(reminder: Reminder) {
        if reminder.type == "near" {
            nearClient.addReminder(reminder)
        } else {
            withClient.addReminder(reminder)
        }
    }
    
    func createReminder(type: String, specifier: String, reminderBody: String)->Bool{
        let newReminder = Reminder(type: type, specifier: specifier, reminderBody: reminderBody)
        addReminder(newReminder)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newReminder, toFile: ReminderClient.ArchiveURL.path!)
        return isSuccessfulSave
    }
    
    func updateReminder(updateId: String, newType: String, newSpecifier: String, newReminderBody : String) {
        for reminder in self.getAllReminders() {
            if(reminder.id == updateId){
                if(reminder.type == newType){
                    //Simple Case
                    reminder.specifier = newSpecifier
                    reminder.reminderBody = newReminderBody
                }
            }
        }
    }
    
    func getAllReminders() -> [Reminder] {
        return nearClient.reminders + withClient.reminders
    }
    
    func getReminder(id:String) -> Reminder? {
        for item:Reminder in getAllReminders() {
            if item.id == id {
                return item
            }
        }
        return nil
    }
    
    // TODO - implement remove reminder
}
