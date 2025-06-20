//
//  OverpassNetworkService.swift
//  Mapverse
//
//  Created by Dave Paiva on 19/06/25.
//

import Foundation

class OverpassNetworkService: BaseNetworkService{
    static let shared = OverpassNetworkService()
    
    init(){
        super.init(baseURL: "https://overpass-api.de/api")
    }
    
}
