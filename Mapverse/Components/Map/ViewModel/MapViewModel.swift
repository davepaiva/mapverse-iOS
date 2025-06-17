//
//  MapVIewModel.swift
//  Mapverse
//
//  Created by Dave Paiva on 17/06/25.
//

import Foundation
import MapLibre
import CoreLocation
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesEnabled() {
        // TODO FIX threading warning
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }else{
            print("Show an alert to tell user that location services is disabled")
        }
    }
    

    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization( )
        case .restricted:
            print("Show an alert - location is restricted")
        case .denied:
            print("Show an alert - location is denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("TODO handle authorizedAlways & authorizedWhenInUse")
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.distanceFilter = 10
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        dump("location0: \(locations.first)")
        userLocation = locations.first
    }
    
}
