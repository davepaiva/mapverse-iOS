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
import GEOSwift

struct CachedPOIData {
    let bounds: MapBounds
    let POIs: [OSMPOI]
}

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cachedOSMPOIs: [CachedPOIData] = []
    @Published var mapPOIs: [OSMPOI] = [] {
        didSet{
            updatePOILayer(with: mapPOIs)
        }
    }
    
    
    var locationManager: CLLocationManager?
    private var mapView: MLNMapView?
    
    // Source and layer identifiers
    private let poiSourceIdentifier = "poi-source"
    private let poiLayerIdentifier = "poi-layer"
    
    
    func checkIfLocationServicesEnabled() {
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
    func fetchPOIs(mapBounds: MapBounds, currentZoomLevel: Double) async {
        if currentZoomLevel <= MapConfiguration.poiZoomThreshold {
            mapPOIs = []
            return
        }
        let cachedData = getCacheWithinBounds(mapBounds)
        guard let cachedData, !cachedData.isEmpty else {
            // no cached data, fetch from server
            print("no cached data, fetch from server")
            do {
                mapPOIs = try await OverpassAPI.fetchMapPOIs(mapBounds: mapBounds)
                cachedOSMPOIs.append(CachedPOIData(bounds: mapBounds, POIs: mapPOIs))
                dump("OSMPOI data: \(mapPOIs)")
            }catch {
                print("OSMPOI TODO show error to user: \(error.localizedDescription)")
            }
            return
        }
        print("using cached data")
        mapPOIs = cachedData
    }
    
    func boundsToPolygon(_ bounds: MapBounds) throws -> Geometry {
        do{
            let coordinates = [
                   CLLocationCoordinate2D(latitude: bounds.south, longitude: bounds.west),
                   CLLocationCoordinate2D(latitude: bounds.south, longitude: bounds.east),
                   CLLocationCoordinate2D(latitude: bounds.north, longitude: bounds.east),
                   CLLocationCoordinate2D(latitude: bounds.north, longitude: bounds.west),
                   CLLocationCoordinate2D(latitude: bounds.south, longitude: bounds.west)
               ]
            var pairs = coordinates.map{String("\($0.longitude) \($0.latitude)")}
            pairs.append(pairs[0])
            let joined = pairs.joined(separator: ", ")
            return try Geometry(wkt: "POLYGON ((\(joined)))")
        }catch{
            print("err while conevrting bounds to geometry: \(error)")
            throw(error)
        }
       
    }
    
    func getCacheWithinBounds(_ mapBounds: MapBounds) -> [OSMPOI]? {
        guard let currentPolygon = try? boundsToPolygon(mapBounds) else { return  nil}
        for cache in cachedOSMPOIs{
            guard let cachedPolygon = try? boundsToPolygon(cache.bounds) else { continue }
            if ((try? currentPolygon.isWithin(cachedPolygon)) != nil){
                return filterCachedPOIs(data: cache, within: mapBounds)
            }
        }
        return nil
    }
    
    func filterCachedPOIs(data cachedData: CachedPOIData ,within currentMapBounds: MapBounds) -> [OSMPOI]{
        let poisResult = cachedData.POIs.filter {
            guard let lat =  $0.center?.lat ?? $0.lat,
                  let lon =  $0.center?.lon ?? $0.lon else{
                return false
            }
    
            return lat >= currentMapBounds.south &&
            lat <= currentMapBounds.north &&
            lon >= currentMapBounds.west &&
            lon <= currentMapBounds.east
            
        }
        
        return poisResult
    }
    
    func getUnCoveredAreas(within mapBounds: MapBounds) -> Geometry? {
        guard let currentPolygon = try? boundsToPolygon(mapBounds) else { return nil}
        
        if(cachedOSMPOIs.isEmpty){
            return currentPolygon
        }
        
        let cachedPolygon = cachedOSMPOIs.compactMap{
            try? boundsToPolygon($0.bounds)
        }
        
        guard !cachedPolygon.isEmpty else {
              return currentPolygon
          }
        
        var unionCached = cachedPolygon[0]
        
        do{
            for  i in 1..<cachedPolygon.count {
                unionCached = try unionCached.union(with: cachedPolygon[i])
            }
            let uncoveredPolygon = try currentPolygon.difference(with: unionCached)
            print("uncovered polygons: \(uncoveredPolygon)")
            return uncoveredPolygon
            
        }catch{
            print("error in finding union of cached polygons: \(error)")
            return currentPolygon
        }
    }
    
}
