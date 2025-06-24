import SwiftUI

struct MapContainerView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        ZStack {
            // Main map view - pass the shared view model
            MapView(viewModel: viewModel)
                .ignoresSafeArea()
            
            // Position the loading indicator at the top
            VStack {
                if viewModel.isFetchingData {
                    HStack(spacing: 8) {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Fetching POIs")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                    )
                    .shadow(radius: 2)
                }
                Spacer()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MapContainerView()
} 
