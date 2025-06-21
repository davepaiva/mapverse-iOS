import Foundation
import CoreLocation
import MapLibre

// MARK: - Map Configuration
struct MapConfiguration {
    static let initialLocation = CLLocationCoordinate2D(latitude: 47.27574, longitude: 11.39085)
    static let initialZoomLevel: Double = 15
    static let initialDistance: CLLocationDistance = 10000
    static let poiZoomThreshold: Double = 16
    static let lowZoomThreshold: Double = 10
    static let defaultPitch: Double = 0
    static let defaultHeading: Double = 0
    
    static let poiSourceIdentifier = "poi-source"
    static let poiLayerIdentifier = "poi-layer"
    
    static let fallbackStyleURL = "https://demotiles.maplibre.org/style.json"
}

// MARK: - Map Style Provider
struct MapStyleProvider {
    static func createOpenStreetMapStyle() -> URL? {
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
            let temporaryDirectory = FileManager.default.temporaryDirectory
            let temporaryFileURL = temporaryDirectory.appendingPathComponent("osm_style.json")
            try styleJSON.write(to: temporaryFileURL, atomically: true, encoding: .utf8)
            
            return temporaryFileURL
        } catch {
            print("Error creating custom style: \(error)")
            return nil
        }
    }
} 
