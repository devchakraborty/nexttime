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

class PlaceAutoCompleteItem:NSObject, MLPAutoCompletionObject {
    var placeItem:GMSAutocompletePrediction
    init(placeItem:GMSAutocompletePrediction) {
        self.placeItem = placeItem
    }
    
    func autocompleteString() -> String! {
        return self.placeItem.attributedFullText.string
    }
}