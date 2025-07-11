//
//  OSMNetworkService.swift
//  Mapverse
//
//  Created by Dave Paiva on 19/06/25.
//

import Foundation

class OSMNetworkService: BaseNetworkService {
    
    static let shared = OSMNetworkService()
    
    private init(){
        super.init(baseURL: "https://api.openstreetmap.org/api/0.6")
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
