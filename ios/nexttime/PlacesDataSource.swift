//
//  PlacesDataSource.swift
//  nexttime
//
//  Created by Dev Chakraborty on 2015-11-07.
//  Copyright © 2015 NextTime. All rights reserved.
//

import Foundation
import UIKit
import MLPAutoCompleteTextField
import MapKit
import GoogleMaps

class PlacesDataSource:NSObject,MLPAutoCompleteTextFieldDataSource {
    
    var localSearch:MKLocalSearch?
    
    static let shared = PlacesDataSource()
    var placesClient:GMSPlacesClient!
    
    let skipTypes:[String:Bool] = ["country": true, "political":true]
    
    override init() {
        super.init()
        GMSServices.provideAPIKey("AIzaSyD_ScjAUus9ph2jckaUCPeSvJ-5dzAMq8w")
        placesClient = GMSPlacesClient()
    }
    
    class func sharedDataSource() -> PlacesDataSource {
        return shared
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, possibleCompletionsForString string: String!, completionHandler handler: (([AnyObject]!) -> Void)!) {
        print("SEARCHING")
        if localSearch != nil && localSearch!.searching {
            localSearch!.cancel()
        }
        
        placesClient.autocompleteQuery(string, bounds: GMSCoordinateBounds(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)), filter:nil) { (response, error) in
            if (error != nil) {
                print("ERROR", error)
                handler([])
                return
            }
            
            print("RESPONSE", response)
            
            var results:[Place] = []
            
            for item:AnyObject in response! {
                let placeItem = item as! GMSAutocompletePrediction
                
                var skipItem = false
                
                for typeObj:AnyObject in placeItem.types {
                    let type = typeObj as! String
                    if (self.skipTypes[type] != nil) {
                        skipItem = true
                    }
                }
                
                if skipItem {
                    continue
                }
                    
                let autoCompleteItem = Place(placeItem: placeItem)
                
                results.append(autoCompleteItem)
            }
            
            handler(results)
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
            
//        print("HERE")
//        
//        let request = MKLocalSearchRequest()
//        
//        request.naturalLanguageQuery = string
//        
//        self.localSearch = MKLocalSearch(request: request)
//        
//        self.localSearch?.startWithCompletionHandler() { (MKLocalSearchResponse response, NSError error) in
//            if (error != nil) {
//                print("ERROR", error)
//                handler([])
//                return
//            }
//            
//            print("RESULTS", response!.mapItems)
//
//            var results:[MKMapAutoCompleteItem] = []
//            for item:MKMapItem in response!.mapItems {
////                if item.placemark.location?.coordinate <= 100 {
//                    results.append(MKMapAutoCompleteItem(mkItem: item))
////                }
//            }
//            handler(results)
//            
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
}