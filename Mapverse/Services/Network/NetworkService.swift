//
//  NetworkService.swift
//  Mapverse
//
//  Created by Dave Paiva on 19/05/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

enum requestContentType: String{
    case URLEncoded = "application/x-www-form-urlencoded"
    case JSON = "application/json"
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case invlaidRequestBody(message: String)
    case serverError(statusCode: Int, message: String)
    case customError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid HTTP response"
        case .decodingError:
            return "Error decoding JSON"
        case .invlaidRequestBody(message: let message):
            return "Invalid request body \(message)"
        case .serverError(statusCode: let statusCode, message: let message):
            return "Server Error (\(statusCode)): \(message)"
        case .customError(message: let message):
            return message
        }
    }
}

protocol RequestParameters: Encodable {
    func asQueryItems() throws -> [URLQueryItem]
}

protocol FormURLParameters: Encodable {
    func asFormURLEncodedItems() -> String
}

extension RequestParameters {
    func asQueryItems() throws -> [URLQueryItem] {
        guard let dictionary = try? self.asDictinary() else{
            return []
        }
        return dictionary.map{URLQueryItem(name: "\($0.key)", value: "\($0.value)") }
    }
    
    private func asDictinary() throws -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        return jsonObject as? [String: Any]
    }
}

extension FormURLParameters{
    func asFormURLEncodedItems() -> String{
        guard let dictionary = try? self.asDictinary() else{
            return ""
        }
        
        return dictionary.reduce(into: [String: String]()){ result, item in
            result[item.key] = "\(item.value)"
        }.map{ key, value in
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
            return "\(encodedKey)=\(encodedValue)"
            
        }.joined(separator: "&")
        
    }
    
    private func asDictinary() throws -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try encoder.encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        return jsonObject as? [String: Any]
    }
}

class NetworkService {
    @EnvironmentKey("OSM_BASE_URL")
    private var BASE_URL:String
    
    static let shared = NetworkService()
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }

    func get<T: Decodable>(
        endpoint: String,
        parameters: RequestParameters
    ) async throws -> T {
        return try await performRequest(endpoint: endpoint, method: .GET, parameters: parameters)
    }

    func post<T: Decodable, U: Encodable>(
        endpoint: String,
        parameters: RequestParameters? = nil,
        body: U? = nil,
        requestContentType: requestContentType = .JSON
    ) async throws -> T {
        return try await performRequest(endpoint: endpoint, method: .POST, parameters: parameters, body: body, requestContentType: requestContentType)
    }
    
    private func buildAPIEndpoint(endpoint: String, parameters: RequestParameters? = nil) throws -> URL{
        var urlString = URLComponents(string: "\(BASE_URL)/\(endpoint)")
        if let parameters = parameters {
            urlString?.queryItems = try? parameters.asQueryItems()
        }
        guard let url = urlString?.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    private func checkForAPIErrors(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
           let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
           throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorMessage)
       }
    }
    
    
    // Mostly used for GET requests
    private func performRequest<T: Decodable>(endpoint: String, method: HTTPMethod, parameters: RequestParameters) async throws -> T {
        let url = try buildAPIEndpoint(endpoint: endpoint, parameters: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("aplication/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            try checkForAPIErrors(response: response, data: data)
            return try decoder.decode(T.self, from: data)
            
        }catch _ as DecodingError{
            throw NetworkError.decodingError
        }catch let error as NetworkError{
            throw error
        }
        
    }

   // Mostly used for POST requests
   private func performRequest<T: Decodable, U: Encodable>(
    endpoint: String,
    method: HTTPMethod,
    parameters: RequestParameters? = nil,
    body: U,
    requestContentType: requestContentType = .JSON
   ) async throws -> T {
       let url = try buildAPIEndpoint(endpoint: endpoint, parameters: parameters)
       var request = URLRequest(url: url)
       request.httpMethod = method.rawValue
       request.setValue(requestContentType.rawValue, forHTTPHeaderField: "Content-Type")
       do{
           switch requestContentType{
           case .JSON:
               request.httpBody = try encoder.encode(body)
           case .URLEncoded:
               guard let formParameters = body as? FormURLParameters else{
                   print("here")
                   throw NetworkError.invlaidRequestBody(message: "Body must conform to FormURLParameters for URL-encoded requests")
               }
               let formBody = formParameters.asFormURLEncodedItems()
               request.httpBody = formBody.data(using: .utf8)
           }
       }catch{
           throw NetworkError.invlaidRequestBody(message: error.localizedDescription)
       }
       do{
           let (data, response) = try await URLSession.shared.data(for: request)
           try checkForAPIErrors(response: response, data: data)
           dump(data)
           return try decoder.decode(T.self, from: data)
           
       }catch let error as DecodingError{
           print(error.localizedDescription)
           throw NetworkError.decodingError
       }catch let error as NetworkError{
           throw error
       }
     
   }
}
