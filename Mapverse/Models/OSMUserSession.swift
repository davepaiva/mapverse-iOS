//
//  OSMUserSession.swift
//  Mapverse
//
//  Created by Dave Paiva on 26/05/25.
//

import Foundation

struct OSMUserSession{
    var accessToken: String
    let tokenType = "Bearer"
    var scope: String
    var createdAt: Int
}
