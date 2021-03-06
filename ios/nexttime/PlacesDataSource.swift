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
        GMSServices.provideAPIKey("AIzaSyDnDpYVFSWYJiL6u_KSaJHa3LSr0IUWAh0")
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
                
                if placeItem.placeID == nil {
                    continue
                }
                
                print("PLACE ID", placeItem.placeID)
                
                var skipItem = false
                
                for typeObj:AnyObject in placeItem.types {
                    let type = typeObj as! String
                    if (self.skipTypes[type] != nil) {
                        skipItem = true
                        break
                    }
                }
                
                if skipItem {
                    continue
                }
                    
                let place = Place(placeName: placeItem.attributedFullText.string, placeId: placeItem.placeID!)
                
                results.append(place)
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