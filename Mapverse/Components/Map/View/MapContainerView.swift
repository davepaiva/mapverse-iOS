import SwiftUI

struct MapContainerView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        ZStack {
            // Main map view
            MapView()
                .ignoresSafeArea()
            
        }
    }
}

// MARK: - Preview
#Preview {
    MapContainerView()
} 
