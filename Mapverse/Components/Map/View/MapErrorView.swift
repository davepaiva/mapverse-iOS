import SwiftUI

struct MapErrorView: View {
    let errorMessage: String
    let retryAction: (() -> Void)?
    
    init(errorMessage: String, retryAction: (() -> Void)? = nil) {
        self.errorMessage = errorMessage
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.system(size: 48))
            
            Text("Something went wrong")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let retryAction = retryAction {
                Button("Try Again") {
                    retryAction()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 8)
        .padding()
    }
}

// MARK: - Preview
#Preview {
    MapErrorView(
        errorMessage: "Unable to fetch Points of Interest. Please check your network connection.",
        retryAction: { print("Retry tapped") }
    )
} 