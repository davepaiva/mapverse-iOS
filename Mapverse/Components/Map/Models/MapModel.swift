//
//  MapModel.swift
//  Mapverse
//
//  Created by Dave Paiva on 24/06/25.
//

import Foundation

struct CachedPOIData {
    let bounds: MapBounds
    let POIs: [OSMPOI]
}

struct OSMPOIInfoResponse: Codable {
    let version: String
    let generator: String
    let copyright: String
    let attribution: String
    let license: String
    let elements: [OSMPOIInfo]
}

struct OSMPOIInfo: Codable {
    let type: OSMNodeType
    let id: Int64
    let lat: Double?  // Optional because ways don't have lat/lon
    let lon: Double?  // Optional because ways don't have lat/lon
    let timestamp: String
    let tags: [String: String]?
    let version: Int
    let changeset: Int
    let user: String
    let uid: Int64
    let nodes: [Int64]?  // This will be populated for ways
}


struct MapFeatureAttributes {
    let poiId: Int64
    let poiType: OSMNodeType
    let tags: [String: String]
    let iconId: String
    
    init?(from attributes: [String: Any]) {
           guard let poiIdNumber = attributes["poiId"] as? NSNumber,
                 let poiTypeString = attributes["poiType"] as? String,
                 let poiType = OSMNodeType(rawValue: poiTypeString),
                 let iconId = attributes["iconId"] as? String else {
               return nil
           }
           
           self.poiId = poiIdNumber.int64Value
           self.poiType = poiType
           self.iconId = iconId
           
           // Handle tags - they might be NSDictionary or [String: String]
           if let tagsDict = attributes["tags"] as? NSDictionary {
               self.tags = tagsDict as? [String: String] ?? [:]
           } else {
               self.tags = [:]
           }
       }
    

}
