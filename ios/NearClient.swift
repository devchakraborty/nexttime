//
//  NearClient.swift
//  nexttime
//
//  Created by Arkady Arkhangorodsky on 2015-11-06.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NearClient {
    var reminders : [Reminder]
    let distanceThreshold = 500.0 // metres
    
    init() {
        reminders = [Reminder]()
    }
    
    func addReminder(reminder: Reminder) {
        reminders.append(reminder)
    }
    
    func getClosestSearchResult(location: CLLocation, reminder: Reminder,
            onReminderTriggered: (Reminder) -> Void) {
        let searchRequest = MKLocalSearchRequest()
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let location2d = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let searchRegion = MKCoordinateRegion(center: location2d, span: span)
        
        searchRequest.naturalLanguageQuery = reminder.specifier
        searchRequest.region = searchRegion
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.startWithCompletionHandler({(response: Optional<MKLocalSearchResponse>,
            error: Optional<NSError>) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                
                for item in response!.mapItems {
                    let itemLocation = item.placemark.location
                    if (itemLocation?.distanceFromLocation(location) < self.distanceThreshold) {
                        onReminderTriggered(reminder)
                    }
                }
            }
        })
    }
    
    func checkReminders(currentLocation: CLLocation, onReminderTriggered: (Reminder) -> Void) {
        // for each reminder in reminders,
        //    Google Maps search for the reminder query (getting closest match)
        //    See if within 100m, if so call onReminderTriggered
        for reminder in reminders {
            getClosestSearchResult(currentLocation, reminder: reminder, onReminderTriggered: onReminderTriggered)
        }
    }
}
    