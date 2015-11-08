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
    var name:String
    
    struct PropertyKey {
        static let id = "friendId"
        static let name = "name"
    }
    
    // MARK: Initialization
    init(id:String, name:String) {
        self.id = id
        self.name = name
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(PropertyKey.id) as! String
        let name = aDecoder.decodeObjectForKey(PropertyKey.name) as! String
        self.init(id:id, name: name)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: PropertyKey.id)
        aCoder.encodeObject(name, forKey: PropertyKey.name)
    }
    
    func autocompleteString() -> String! {
        return self.name
    }
}
