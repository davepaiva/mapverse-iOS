import SwiftUI
import MapLibre
import CoreLocation

struct MapView: UIViewRepresentable {
    @StateObject private var viewModel =  MapViewModel()
    
    
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()
        configureMapView(mapView)
        viewModel.setMapView(mapView)
        mapView.delegate = context.coordinator
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
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MLNMapView, regionDidChangeWith reason: MLNCameraChangeReason, animated: Bool) {
            let currentZoomLevel = mapView.zoomLevel
            print("Zoom level changed to: \(currentZoomLevel)")
            
            // Fetch POIs when zoom level is high enough
            if currentZoomLevel > MapConfiguration.poiZoomThreshold {
                let bounds = MapBounds(
                    south: mapView.visibleCoordinateBounds.sw.latitude,
                    west: mapView.visibleCoordinateBounds.sw.longitude,
                    north: mapView.visibleCoordinateBounds.ne.latitude,
                    east: mapView.visibleCoordinateBounds.ne.longitude
                )
                Task{
                    await parent.viewModel.fetchPOIs(mapBounds: bounds)
                }
               
            } else if currentZoomLevel < MapConfiguration.lowZoomThreshold {
                print("Low zoom level - hiding detailed POIs")
                // Optionally clear POIs at low zoom levels
                // parent.viewModel.clearPOIs()
            }
        }
        
        private func mapView(_ mapView: MLNMapView, didFailToLoadMapWithError error: Error) {
            print("Map failed to load: \(error.localizedDescription)")
            // Could forward this error to the view model
        }
    }
}
