//
//  ReminderClient.swift
//  nexttime
//
//  Created by Arkady Arkhangorodsky on 2015-11-07.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit

class ReminderClient {
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("reminders")
    
    var nearClient: NearClient
    var withClient: WithClient
    
    init() {
        nearClient = NearClient()
        withClient = WithClient()
        let reminders = NSKeyedUnarchiver.unarchiveObjectWithFile(ReminderClient.ArchiveURL.path!) as? [Reminder]
        for reminder in reminders! {
            addReminder(reminder)
        }
    }
    
    func addReminder(reminder: Reminder) {
        if reminder.type == "near" {
            nearClient.addReminder(reminder)
        } else {
            withClient.addReminder(reminder)
        }
    }
    
    func createReminder(type: String, place: String, reminderBody: String)->Bool{
        let newReminder = Reminder(type: type, specifier: place, reminderBody: reminderBody)
        addReminder(newReminder)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newReminder, toFile: ReminderClient.ArchiveURL.path!)
        return isSuccessfulSave
    }
}
