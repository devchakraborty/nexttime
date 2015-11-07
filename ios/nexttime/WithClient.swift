//
//  WithClient.swift
//  nexttime
//
//  Created by Arkady Arkhangorodsky on 2015-11-06.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit

class WithClient {
    var reminders : [Reminder]
    
    init() {
        reminders = [Reminder]()
    }
    
    func addReminder(reminder: Reminder) {
        reminders.append(reminder)
    }
}