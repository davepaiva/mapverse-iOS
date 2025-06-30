import SwiftUI
import MapLibre
import CoreLocation

struct MapView: UIViewRepresentable {
    @StateObject var viewModel: MapViewModel
    
    
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()
        configureMapView(mapView)
        viewModel.setMapView(mapView)
        mapView.delegate = context.coordinator
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        return mapView
    }
    
    func updateUIView(_ uiView: MLNMapView, context: Context) {
        // Handle any updates needed when SwiftUI state changes
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func configureMapView(_ mapView: MLNMapView) {
        // Set style
        if let customStyleURL = MapStyleProvider.createOpenStreetMapStyle() {
            mapView.styleURL = customStyleURL
        } else {
            mapView.styleURL = URL(string: MapConfiguration.fallbackStyleURL)
        }
        
        // Set initial camera position
        let camera = MLNMapCamera(
            lookingAtCenter: MapConfiguration.initialLocation,
            acrossDistance: MapConfiguration.initialDistance,
            pitch: MapConfiguration.defaultPitch,
            heading: MapConfiguration.defaultHeading
        )
        mapView.setCamera(camera, animated: true)
        
        // Configure location and zoom
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.zoomLevel = MapConfiguration.initialZoomLevel
    }
}

// MARK: - Coordinator
extension MapView {
    class Coordinator: NSObject, MLNMapViewDelegate {
        let parent: MapView
        private var lastZoomLevel: Double = 0
        private var lastCenterCoordinate: CLLocationCoordinate2D?
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MLNMapView, regionDidChangeWith reason: MLNCameraChangeReason, animated: Bool) {
            let currentZoomLevel = mapView.zoomLevel
            let currentCenterCoordinate = mapView.centerCoordinate
            print("Region changed - Zoom: \(currentZoomLevel), Center: \(currentCenterCoordinate)")
            let zoomChanged = abs(currentZoomLevel - lastZoomLevel) > 0.1
            let centerChanged = hasCenterChangedSignificantly(from: lastCenterCoordinate, to: currentCenterCoordinate)
            
            guard zoomChanged || centerChanged else { return }

            lastZoomLevel = currentZoomLevel
            lastCenterCoordinate = currentCenterCoordinate

            let bounds = MapBounds(
                south: mapView.visibleCoordinateBounds.sw.latitude,
                west: mapView.visibleCoordinateBounds.sw.longitude,
                north: mapView.visibleCoordinateBounds.ne.latitude,
                east: mapView.visibleCoordinateBounds.ne.longitude
            )
            Task{
                await parent.viewModel.fetchPOIs(mapBounds: bounds, currentZoomLevel: currentZoomLevel)
            }
        }

         private func hasCenterChangedSignificantly(from lastCenter: CLLocationCoordinate2D?, to currentCenter: CLLocationCoordinate2D) -> Bool {
            guard let lastCenter = lastCenter else { return true } // First time, always update
            
            // Calculate distance moved (you can adjust this threshold based on your needs)
            let latDiff = abs(currentCenter.latitude - lastCenter.latitude)
            let lonDiff = abs(currentCenter.longitude - lastCenter.longitude)
            
            // Threshold for significant movement (roughly 100 meters at equator)
            let threshold = 0.001
            
            return latDiff > threshold || lonDiff > threshold
        }
        
        private func mapView(_ mapView: MLNMapView, didFailToLoadMapWithError error: Error) {
            print("Map failed to load: \(error.localizedDescription)")
            // Could forward this error to the view model
        }
        
        @objc func handleMapTap(_ gesture: UITapGestureRecognizer){
            guard let mapView = gesture.view as? MLNMapView else { return }
            
            let tapPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let layerIdentifiers = [parent.viewModel.poiLayerIdentifier]
            let visibleFeatures = mapView.visibleFeatures(at: tapPoint, styleLayerIdentifiers: Set(layerIdentifiers))
            
            if !visibleFeatures.isEmpty {
                guard let rawAttributes = visibleFeatures.first?.attributes else { return }
                guard let coords = visibleFeatures.first?.coordinate else { return }
                
                guard let featureAttributes = MapFeatureAttributes(from: rawAttributes) else { return }
                
                Task{
                    await parent.viewModel.handlePOITap(poiId: featureAttributes.poiId, coordinate: coords, attributes: featureAttributes)
                }
               
            }
            
            
        }
    }
}
