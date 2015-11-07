//
//  MKMapAutoCompleteItem.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-07.
//  Copyright © 2015 NextTime. All rights reserved.
//

import Foundation
import MLPAutoCompleteTextField
import GoogleMaps
import MapKit

class Place:NSObject, MLPAutoCompletionObject {
    var placeName:String
    var placeId:String
    
    init(placeName:String, placeId:String) {
        self.placeName = placeName
        self.placeId = placeId
    }
    
    func autocompleteString() -> String! {
        return self.placeName
    }
}