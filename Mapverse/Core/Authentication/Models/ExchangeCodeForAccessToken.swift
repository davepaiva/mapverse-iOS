//
//  ExchangeCodeForAccessToken.swift
//  Mapverse
//
//  Created by Dave Paiva on 20/05/25.
//

import Foundation

struct ExchangeCodeForAccessTokenRequestBody: Codable, FormURLParameters {
    let grantType: String = "authorization_code"
    var code: String = ""
    let redirectUri: String = AuthConfig.redirectUri
    let clientId: String = AuthConfig.clientId
    
    enum CodingKeys: String, CodingKey {
         case grantType = "grant_type"
         case code
         case redirectUri = "redirect_uri"
         case clientId = "client_id"
     }
}

struct ExchangeCodeForAccessTokenResponseBody: Decodable{
    var accessToken: String?
    var tokenType: String
    var scope: String
    var createdAt: Int
}
