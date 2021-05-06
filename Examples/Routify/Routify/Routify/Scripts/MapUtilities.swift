//
//  MapUtilities.swift
//  Routify
//
//  Created by iosdev on 29.4.2021.
//

import Foundation
import MapKit
import Firebase // GeoPoint


// Usage:
// let value: TimeInterval = 12600.0
// value.format(using: [.hour, .minute, second])!
extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: self)
    }
}

// Provides us polyline for graphics and its distance and duration
func pathToData(start : GeoPoint, end : GeoPoint, resultDeleg : @escaping (MKPolyline?, CLLocationDistance?, TimeInterval?, Error?) -> Void)
   {
       let pointStart = MKMapItem(placemark: MKPlacemark(coordinate:CLLocationCoordinate2D(latitude: start.latitude, longitude: start.longitude), addressDictionary: nil))
       
       let pointEnd = MKMapItem(placemark: MKPlacemark(coordinate:CLLocationCoordinate2D(latitude: end.latitude, longitude: end.longitude), addressDictionary: nil))
       
       let directionRequest = MKDirections.Request()
       directionRequest.source = pointStart
       directionRequest.destination = pointEnd
       directionRequest.transportType = .walking
       let directions = MKDirections(request: directionRequest)
       
       directions.calculate() {
           (response, error) -> Void in
           
           guard let response = response else {
               if let error = error {
                   
                   print("Error: \(error)")
                   resultDeleg(nil,nil,nil, error)
               }
               return
           }
           
           resultDeleg(response.routes[0].polyline,response.routes[0].distance, response.routes[0].expectedTravelTime, nil)
       }
   }

// Provides us polyline for graphics and its distance and duration
func cordsToPoly(cords: [GeoPoint]) -> MKPolyline
   {
    var mapcordarr: [CLLocation] = []
    for cord in cords {
        mapcordarr.append(
            CLLocation(latitude: cord.latitude, longitude: cord.longitude)
        )
    }
    
    var coordinates = mapcordarr.compactMap({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
    return MKPolyline(coordinates: &coordinates, count: mapcordarr.count)
   }
