import SwiftUI
import MapLibre


struct MapView: UIViewRepresentable{
    
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView()
        return mapView
    }
    
    func updateUIView(_ uiView: MLNMapView, context: Context) {
        
    }
}
