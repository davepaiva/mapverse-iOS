import SwiftUI

struct LoginView: View {
    @StateObject private var viewmodel = AuthViewModel()
    
    var body: some View {
            VStack(spacing: 0) {
                VStack {
                    Spacer()
                    Text("Welcome to the Mapverse")
                        .font(.title)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    Button(action: {
                        viewmodel.startOAuthFlow()
                    }) {
                        Label("Signin using OSM", systemImage: "person.fill")
                            .symbolEffect(.bounce, value: viewmodel.isAuthenticating)
                    }
                    .modifier(ButtonViewModifier(isLoading: viewmodel.isAuthenticating))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding()
            .sheet(isPresented: $viewmodel.showWebView, onDismiss: {
                if viewmodel.hasUserPressedDoneInWebviewSheet == false {
                    viewmodel.cancelAuthentication()
                }
            }) {
                NavigationStack {
                    ZStack {
                        Webview(isLoading: $viewmodel.isWebviewLoading, currentURL: $viewmodel.currentWebviewUrl)
                        if viewmodel.isWebviewLoading {
                            Color.black.opacity(0.2)
                                .ignoresSafeArea()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading){
                            Button("Cancel"){
                                viewmodel.cancelAuthentication()
                            }
                        }
                        
                        if viewmodel.hasAuthorizationCode == true {
                            ToolbarItem(placement: .navigationBarTrailing){
                                Button("Done"){
                                    viewmodel.handleWebviewDoneOnPress()
                                }
                            }
                        }
                    }
                    .alert("Authorization Code Received", isPresented: $viewmodel.showAuthCodeAlert) {
                        Button("Continue") {
                            viewmodel.showAuthCodeAlert = false
                        }
                    } message: {
                        Text("Your authorization code has been received. Copy this code and paste it into the textfiled in the next step.")
                    }
                }
            }
            .sheet(isPresented: $viewmodel.showAuthCodeInput, onDismiss: {
                if viewmodel.isAuthenticationCompleted == false {
                    viewmodel.cancelAuthentication()
                }
            }) {
                AuthCodeInputView(viewmodel: viewmodel)
            }
        }
    }

#Preview {
    NavigationStack{
        LoginView()
    }
}
