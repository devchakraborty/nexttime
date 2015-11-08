//
//  WithClient.swift
//  nexttime
//
//  Created by Arkady Arkhangorodsky on 2015-11-06.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKCoreKit
import MapKit
import Firebase

class WithClient {
    var reminders : [Reminder]
    var onReminderTriggered : (Reminder) -> Void
    var latestLocation : CLLocation
    var facebookId : String?
    
    let distanceThreshold = 100.0
    
    init(onReminderTriggered : (Reminder) -> Void) {
        reminders = [Reminder]()
        self.onReminderTriggered = onReminderTriggered
        self.latestLocation = CLLocation(latitude: CLLocationDegrees(37.78),
                                        longitude: CLLocationDegrees(-122.41))
    }
    
    func addReminder(reminder: Reminder) {
        reminders.append(reminder)
        let firebaseRef = Firebase(url: "https://nexttime.firebaseio.com/locations/" + facebookId!)
        firebaseRef.observeEventType(.ChildChanged, withBlock: {snapshot in
            let latitude = CLLocationDegrees(snapshot.value.objectForKey("lat") as! Double)
            let longitude = CLLocationDegrees(snapshot.value.objectForKey("lng") as! Double)
            let newFriendLocation = CLLocation(latitude: latitude, longitude: longitude)
            if (newFriendLocation.distanceFromLocation(self.latestLocation) < self.distanceThreshold) {
                self.onReminderTriggered(reminder)
            }
        })
    }
    
    func findCloseFriends(location: CLLocation, onReminderTriggered: (Reminder) -> Void) {
        // IMPLEMENT
        // search for location data (from Parse) for friends in your reminder list
        // if they are close, activate reminder
        /* for reminder in self.reminders {
            if friend(reminder.specifier).distance < 100 {
               onReminderTriggered(reminder)
            }
        }*/
    }
    
    func checkReminders(currentLocation: CLLocation, onReminderTriggered: (Reminder) -> Void) {
        // find which reminders should be activated (wrapper for findCloseFriends)
        findCloseFriends(currentLocation, onReminderTriggered: onReminderTriggered)
    }
    
    func generateFriend(id: String, name: String) -> Friend {
        /* Generate Friend object given
        id : String
        firstName: String
        lastName: String
        */
        let friend = Friend.init(id: id, name: name)
        return friend
    }
    
    func updateLocation(newLocation: CLLocation) {
        self.latestLocation = newLocation
    }
    
    func generateLocation(longitude: Double, latitude: Double) -> CLLocation {
        /* Generate CLLocation object given
        longitude: Double
        latitutde: Double
        */
        let latitude = CLLocationDegrees.init(latitude)
        let longitude = CLLocationDegrees.init(longitude)
        let location = CLLocation.init(latitude: latitude, longitude: longitude)
        return location
    }
    
    func removeReminder(reminder: Reminder) {
        reminders.removeAtIndex(reminders.indexOf(reminder)!)
    }
}