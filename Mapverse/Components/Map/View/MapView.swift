import SwiftUI
import MapLibre
import CoreLocation

struct MapView: UIViewRepresentable {
    @StateObject private var viewModel =  MapViewModel()
    
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()
        
        viewModel.checkIfLocationServicesEnabled()
        
        // Try custom OpenStreetMap style using the temporary file approach
        if let customStyleURL = createOpenStreetMapStyle() {
            mapView.styleURL = customStyleURL
        } else {
            // Fallback to working demo style
            mapView.styleURL = URL(string: "https://demotiles.maplibre.org/style.json")
        }
        
        // Set initial camera position (similar to web version)
        let camera = MLNMapCamera(
            lookingAtCenter: CLLocationCoordinate2D(latitude: 47.27574, longitude: 11.39085),
            acrossDistance: 10000, // Approximate distance for zoom level 12
            pitch: 0, // Start with 0 pitch, can be adjusted
            heading: 0
        )
        mapView.setCamera(camera, animated: true)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        return mapView
    }
    
    func updateUIView(_ uiView: MLNMapView, context: Context) {
    }
    
    
    private func createOpenStreetMapStyle() -> URL? {
        // if we used regular we based URLs I get a blank black screen with MapLibre logo. Therefore:
        // we create a temp fileand use the filesystem url instead of web based urls according to this discussion https://github.com/maplibre/maplibre-native/discussions/1411
        let styleJSON = """
        {
            "version": 8,
            "name": "OpenStreetMap Style",
            "glyphs": "https://demotiles.maplibre.org/font/{fontstack}/{range}.pbf",
            "sources": {
                "osm": {
                    "type": "raster",
                    "tiles": ["https://a.tile.openstreetmap.org/{z}/{x}/{y}.png"],
                    "tileSize": 256,
                    "attribution": "© OpenStreetMap Contributors",
                    "maxzoom": 19
                }
            },
            "layers": [
                {
                    "id": "osm",
                    "type": "raster",
                    "source": "osm"
                }
            ]
        }
        """
        
        do {
            // Create temporary file URL
            let temporaryDirectory = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryDirectory.appendingPathComponent("osm_style.json")
            
            // Write JSON to temporary file
            try styleJSON.write(to: temporaryFileURL, atomically: true, encoding: .utf8)
            
            return temporaryFileURL
        } catch {
            print("Error creating custom style: \(error)")
            return nil
        }
    }
}
