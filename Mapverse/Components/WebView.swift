import SwiftUI
import WebKit

struct Webview: UIViewRepresentable{
    @Binding var isLoading: Bool
    @Binding var currentURL: URL?
    var javascriptToInject: String?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        
        let webview = WKWebView(frame: .zero, configuration: configuration)
        webview.navigationDelegate = context.coordinator
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: Context) {
        if let url = currentURL, webview.url == nil {
            let request = URLRequest(url: url)
            webview.load(request)
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: Webview
        private var navigationInProgress = false
        
        init(_ parent: Webview) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if !navigationInProgress {
                navigationInProgress = true
                parent.isLoading = true
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            navigationInProgress = false
            parent.isLoading = false
            parent.currentURL = webView.url
            
            // Inject JavaScript after the page is loaded
            if let script = parent.javascriptToInject {
                webView.evaluateJavaScript(script) { result, error in
                    if let error = error {
                        print("JavaScript injection error: \(error.localizedDescription)")
                    }
                }
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            navigationInProgress = false
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            navigationInProgress = false
            parent.isLoading = false
        }
    }
}


#Preview {
    Webview(
        isLoading: .constant(false),
        currentURL: .constant(URL(string: "https://google.com")),
        javascriptToInject: """
            // Example JavaScript that modifies the page
            document.body.style.backgroundColor = '#f0f0f0';
            
            // Add a custom message at the top of the page
            const banner = document.createElement('div');
            banner.innerHTML = '<h3>Custom message injected by the app</h3>';
            banner.style.padding = '10px';
            banner.style.backgroundColor = '#007aff';
            banner.style.color = 'white';
            banner.style.textAlign = 'center';
            
            // Insert at the beginning of the body
            document.body.insertBefore(banner, document.body.firstChild);
            
            // You can also access and modify DOM elements
            // const headings = document.querySelectorAll('h1, h2');
            // headings.forEach(h => h.style.color = 'red');
            
            console.log('JavaScript successfully injected!');
        """
    )
}
