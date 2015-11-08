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
        newLocationManager.distanceFilter = 500
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
        // TODO: Send updated location to server
        nearClient.checkReminders(latestLocation, onReminderTriggered : self.onReminderTriggered)
    }
    
    @objc func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        manager.stopUpdatingLocation()
        manager.startUpdatingLocation()
    }
    
    // MARK: Reminder managing functions
    
    func onReminderTriggered(reminder: Reminder) {
        localNotification(reminder)
    }
    
    func localNotification( reminder : Reminder){
        let notification = UILocalNotification()
        notification.alertAction = "Yes"
        notification.alertBody = "You are near " + reminder.specifier + ", " + reminder.reminderBody + "?"
        notification.category = "REMINDER_CATEGORY"
        notification.userInfo = [NSObject : AnyObject]()
        notification.userInfo!["reminderId"] = reminder.id
        
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        
//        let request = NSMutableURLRequest(URL: NSURL(string: "https://httpbin.org/get")!)
//        print("Sending request")
//        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
//        do {
//            try print(NSURLConnection.sendSynchronousRequest(request, returningResponse: response))
//        } catch {
//            print("Chill")
//        }
//        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
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
    
    func completeReminder(idToRemove: String) {
        for reminder in self.getAllReminders() {
            if (reminder.id == idToRemove) {
                if (reminder.type == "near") {
                    nearClient.removeReminder(reminder)
                } else {
                    withClient.removeReminder(reminder)
                }
            }
        }
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
