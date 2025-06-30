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
                if viewModel.isFetchingPOIs {
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
        }.sheet(isPresented: $viewModel.showNodeInfoBottomSheet, onDismiss: viewModel.onInfoBottomSheetDismissed){
            NodeInfoBottomSheet(
                showNodeInfoBottomSheet: $viewModel.showNodeInfoBottomSheet,
                selectedPOIAttributes: viewModel.selectedPOIAttributes ?? nil,
                selectedPOIOSMInfo: viewModel.selectedPOIOSMInfo
            )
        }
        
    }
}

// MARK: - Preview
#Preview {
    MapContainerView()
} 
