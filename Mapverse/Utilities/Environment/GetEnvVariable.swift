//
//  GetEnvVariable.swift
//  Mapverse
//
//  Created by Dave Paiva on 19/06/25.
//

import Foundation

struct GetEnvVariable {
    
    @EnvironmentKey("OSM_BASE_URL")
    static var osmBaseUrl: String
    
    
}
