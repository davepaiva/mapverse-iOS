import SwiftUI

class AuthViewModel: ObservableObject{
    @Published var isAuthenticating: Bool = false
    @Published var showWebView: Bool = false
    @Published var showAuthCodeInput = false
    @Published var error: Error?
    @Published var user: OSMUser?
    @Published var isWebviewLoading = false
    @Published var isAuthenticationCompleted = false
    @Published var isCodeExchangeLoading = false
    @Published var currentWebviewUrl: URL? = AuthService.shared.createOsmLoginWebviewURL(){
        didSet{
            if let url = currentWebviewUrl {
                let hasCode = url.queryParameters["code"] != nil
                showAuthCodeAlert = hasCode
            }
        }
    }
    @Published var showAuthCodeAlert = false
    @Published var authCode: String = ""
    @Published var hasUserPressedDoneInWebviewSheet: Bool = false
    
    var hasAuthorizationCode: Bool {
        currentWebviewUrl?.queryParameters["code"] != nil
    }
    
    
    func startOAuthFlow(){
        isAuthenticating = true
        showWebView = true
    }
    
    func toggleAuthCodeInput(){
        showWebView=false
        showAuthCodeInput=true
    }
    
    func cancelAuthentication(){
        print("canceling auth")
        isAuthenticating=false
        showWebView=false
        showAuthCodeInput=false
    }
    
    func handleWebviewDoneOnPress(){
        hasUserPressedDoneInWebviewSheet = true
        toggleAuthCodeInput()
    }
    
    @MainActor
    func handleExchangeCodeForAuthToken() async {
        do{
            isCodeExchangeLoading = true
            try await AuthService.shared.exchangeCodeForToken(authCode)
            print("exchange done")
            isAuthenticationCompleted = true
            cancelAuthentication()
        }catch{
            print("error in exchanging code: \(error)")
        }
        isCodeExchangeLoading = false
    }
    
}
