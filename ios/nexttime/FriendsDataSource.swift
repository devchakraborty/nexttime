//
//  FriendsDataSource.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-07.
//  Copyright © 2015 NextTime. All rights reserved.
//

import Foundation
import UIKit
import MLPAutoCompleteTextField
import MapKit

class FriendsDataSource:NSObject,MLPAutoCompleteTextFieldDataSource {
    
    var localSearch:MKLocalSearch?
    var friends:[Friend] = []
    
    static let shared = FriendsDataSource()
    
    class func sharedDataSource() -> FriendsDataSource {
        return shared
    }
    
    func setFriendList(friends: [Friend]) {
        self.friends = friends
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!, completionHandler handler: (([AnyObject]!) -> Void)!) {
        handler(friends)
    }
}