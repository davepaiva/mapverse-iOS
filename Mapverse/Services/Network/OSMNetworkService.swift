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
        super.init(baseURL: GetEnvVariable.osmBaseUrl)
    }
}
