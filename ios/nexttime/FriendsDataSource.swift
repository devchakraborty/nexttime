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
    
    static let shared = FriendsDataSource()
    
    class func sharedDataSource() -> FriendsDataSource {
        return shared
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!, completionHandler handler: (([AnyObject]!) -> Void)!) {
        handler([Friend(id: "1234", firstName: "Dev", lastName: "Chakraborty")])
    }
}