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
//    @Published var userLocation: [CLLocation]? = []
    @Published var OSMPOIs: [OSMPOI] = [] {
        didSet{
            updatePOILayer(with: OSMPOIs)
        }
    }
    
    
    var locationManager: CLLocationManager?
    private var mapView: MLNMapView?
    
    // Source and layer identifiers
    private let poiSourceIdentifier = "poi-source"
    private let poiLayerIdentifier = "poi-layer"
    
    
    func checkIfLocationServicesEnabled() {
        // TODO FIX threading warning
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }else{
            print("Show an alert to tell user that location services is disabled")
        }
    }
    
    func setMapView(_ mapView: MLNMapView) {
        self.mapView = mapView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.setupPOILayer()
        }
    }
    
    private func setupPOILayer() {
        guard let mapView = mapView else { return }
        
        guard mapView.style != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.setupPOILayer()
            }
            return
        }
        
        let source = MLNShapeSource(identifier: poiSourceIdentifier, features: [], options: nil)
        mapView.style?.addSource(source)
        
        let layer = MLNSymbolStyleLayer(identifier: poiLayerIdentifier, source: source)
        layer.iconImageName = NSExpression(forKeyPath: "iconId")
        layer.iconScale = NSExpression(forConstantValue: 1.0)
        layer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        layer.iconIgnoresPlacement = NSExpression(forConstantValue: true)
        layer.iconAnchor = NSExpression(forConstantValue: "center")
        mapView.style?.addLayer(layer)
    }
    
    private func updatePOILayer(with pois: [OSMPOI]) {
        guard let mapView = mapView else { return }
        guard let source = mapView.style?.source(withIdentifier: poiSourceIdentifier) as? MLNShapeSource else { return }
        
        var features: [MLNPointFeature] = []
        
        for poi in pois {
            let feature = MLNPointFeature()
            
            if let lat = poi.lat, let lon = poi.lon {
                feature.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            }else if let center = poi.center {
                feature.coordinate = CLLocationCoordinate2D(latitude: center.lat, longitude: center.lon)
            }else{
                continue
            }
            
            let iconEmoji = poi.icon
            let iconImage = POIIconGenerator.createIcon(emoji: iconEmoji)
            let iconId = "poi-icon-\(poi.id)"
            
            mapView.style?.setImage(iconImage, forName: iconId)
            feature.attributes["iconId"] = iconId
            features.append(feature)
        }
        
        let featureCollection = MLNShapeCollectionFeature(shapes: features)
        
        
        source.shape = featureCollection
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
        guard let locationsFirst = locations.first else { return }
    }
    
    @MainActor
    func fetchPOIs(mapBounds: MapBounds) async {
        do {
            OSMPOIs = try await OverpassAPI.fetchMapPOIs(mapBounds: mapBounds)
            dump("OSMPOI data: \(OSMPOIs)")
        }catch {
            print("OSMPOI TODO show error to user: \(error.localizedDescription)")
        }
       
    }
    
}
