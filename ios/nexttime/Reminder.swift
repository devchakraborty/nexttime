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
    var specifierId: String
    var reminderBody: String
    var id: String
    
    struct PropertyKey {
        static let type = "type"
        static let specifier = "specifier"
        static let specifierId = "specifierId"
        static let reminderBody = "reminderBody"
        static let id = "id"
    }
    
    // MARK: Initialization
    init(type: String, specifier: String, reminderBody: String) {
        self.type = type
        self.specifier = specifier
        self.specifierId = NSUUID().UUIDString
        self.reminderBody = reminderBody
        self.id = NSUUID().UUIDString
        
        super.init()
    }
    
    init(type: String, specifier: String, specifierId: String, reminderBody: String, id: String) {
        self.type = type
        self.specifier = specifier
        self.specifierId = specifierId
        self.reminderBody = reminderBody
        self.id = id
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(type, forKey: PropertyKey.type)
        aCoder.encodeObject(specifier, forKey: PropertyKey.specifier)
        aCoder.encodeObject(specifierId, forKey: PropertyKey.specifierId)
        aCoder.encodeObject(reminderBody, forKey: PropertyKey.reminderBody)
        aCoder.encodeObject(id, forKey: PropertyKey.id)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let type = aDecoder.decodeObjectForKey(PropertyKey.type) as! String
        let specifier = aDecoder.decodeObjectForKey(PropertyKey.specifier) as! String
        let specifierId = aDecoder.decodeObjectForKey(PropertyKey.specifierId) as! String
        let reminderBody = aDecoder.decodeObjectForKey(PropertyKey.reminderBody) as! String
        let id = aDecoder.decodeObjectForKey(PropertyKey.id) as! String
        self.init(type: type, specifier: specifier, specifierId: specifierId, reminderBody : reminderBody, id: id)
     }
}