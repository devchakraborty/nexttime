//
//  Friend.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-07.
//  Copyright © 2015 NextTime. All rights reserved.
//

import UIKit
import MLPAutoCompleteTextField

class Friend: NSObject, NSCoding, MLPAutoCompletionObject {
    // MARK: Properties
    
    var id:String
    var firstName:String
    var lastName:String
    
    struct PropertyKey {
        static let id = "friendId"
        static let firstName = "firstName"
        static let lastName = "lastName"
    }
    
    // MARK: Initialization
    init(id:String, firstName:String, lastName:String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(PropertyKey.id) as! String
        let firstName = aDecoder.decodeObjectForKey(PropertyKey.firstName) as! String
        let lastName = aDecoder.decodeObjectForKey(PropertyKey.lastName) as! String
        self.init(id:id, firstName: firstName, lastName: lastName)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: PropertyKey.id)
        aCoder.encodeObject(firstName, forKey: PropertyKey.firstName)
        aCoder.encodeObject(lastName, forKey: PropertyKey.lastName)
    }
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
    
    func autocompleteString() -> String! {
        return self.fullName()
    }
}
