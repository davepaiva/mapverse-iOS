//
//  OSMNetworkService.swift
//  Mapverse
//
//  Created by Dave Paiva on 19/06/25.
//

import Foundation

class OSMAuthNetworkService: BaseNetworkService {
    
    static let shared = OSMAuthNetworkService()
    
    private init(){
        super.init(baseURL: GetEnvVariable.osmBaseUrl)
    }
    
    override var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    override func getDefaultHeaders() -> [String: String] {
        return [
            "Accept": "application/json",
            "Accept-Language": "en-US,en;q=0.9"
        ]
    }
}
