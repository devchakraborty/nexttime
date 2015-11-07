//
//  Reminder.swift
//  nexttime
//
//  Created by Arkady Arkhangorodsky on 2015-11-06.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit

class Reminder: NSObject, NSCoding {
    // MARK: Properties
    
    var type: String
    var specifier: String
    var reminderBody: String
    
    struct PropertyKey {
        static let type = "type"
        static let specifier = "specifier"
        static let reminderBody = "reminderBody"
    }
    
    // MARK: Initialization
    init(type: String, specifier: String, reminderBody: String) {
        self.type = type
        self.specifier = specifier
        self.reminderBody = reminderBody
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(type, forKey: PropertyKey.type)
        aCoder.encodeObject(specifier, forKey: PropertyKey.specifier)
        aCoder.encodeObject(reminderBody, forKey: PropertyKey.reminderBody)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let type = aDecoder.decodeObjectForKey(PropertyKey.type) as! String
        let specifier = aDecoder.decodeObjectForKey(PropertyKey.specifier) as! String
        let reminderBody = aDecoder.decodeObjectForKey(PropertyKey.reminderBody) as! String
        self.init(type: type, specifier: specifier, reminderBody : reminderBody)
     }
}