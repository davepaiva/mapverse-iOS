import Foundation
import KeychainSwift
import Combine

struct AuthConfig {
    @EnvironmentKey("OSM_CLIENT_ID")
    static var clientId: String
    @EnvironmentKey("OSM_BASE_URL")
    static var baseURL: String
    static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    static let authURL = "\(baseURL)/oauth2/authorize"
    static let tokenURL = "\(baseURL)/oauth2/token"
    static let scopes = [
        "read_prefs",
        "write_prefs",
        "write_api", // to modify the map
        "write_changeset_comments",
        "read_gpx",
        "write_gpx",
        "write_notes",
        "openid"
       ]
}

enum AuthError: Error {
    case invalidURL
    case invalidCode
    case networkError(Error)
    case invalidResponse
    case authorizationFailed
    case decodingError
    case serverError(statusCode: Int, message: String?)
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .invalidCode:
            return "Invalid authorization code"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .authorizationFailed:
            return "Authorization failed"
        case .decodingError:
            return "Failed to decode resoonse"
        case .serverError(let statusCode, let message):
            return "Server error: \(statusCode), \(message ?? "No additional message")"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

class AuthService {
    @Published var currentUserAccessToken: String?
    
    static let shared = AuthService()
    
    let keychain = KeychainSwift()
    
    init(){
        // used for testing auth:
    //    keychain.delete(KeychainKeys.OsmUserAccessToken.rawValue)
        currentUserAccessToken = keychain.get(KeychainKeys.OsmUserAccessToken.rawValue)
       
    }
    
    func createOsmLoginWebviewURL() -> URL? {
        var components = URLComponents(string: AuthConfig.authURL)
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: AuthConfig.clientId),
            URLQueryItem(name: "redirect_uri", value: AuthConfig.redirectUri),
            URLQueryItem(name: "scope", value: AuthConfig.scopes.joined(separator: " "))
        ]
        return components?.url
    }
    
    func exchangeCodeForToken(_ code: String) async throws {
        let response: ExchangeCodeForAccessTokenResponseBody = try await NetworkService.shared.post(endpoint: "/oauth2/token", body: ExchangeCodeForAccessTokenRequestBody(code: code), requestContentType: .URLEncoded)
        guard let token  = response.accessToken else {
            throw NetworkError.customError(message: "OSM access token could not be retreived")
        }
        keychain.set(token, forKey: KeychainKeys.OsmUserAccessToken.rawValue)
        await MainActor.run {
            currentUserAccessToken = token
        }
        print("saved token to keychain")
    }
}
