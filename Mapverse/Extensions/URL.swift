import Foundation

extension URL {
    var queryParameters: [String: String] {
        var params = [String: String]()
        URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .forEach { params[$0.name] = $0.value }
        return params
    }
}

