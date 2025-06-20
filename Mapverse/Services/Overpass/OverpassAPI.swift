//
//  Overpass.swift
//  Mapverse
//
//  Created by Dave Paiva on 19/06/25.
//

import Foundation

struct MapBounds {
    let south : Double
    let west : Double
    let north : Double
    let east : Double
}

enum OSMNodeType: String, Codable {
    case node
    case way
    case relation
}

struct POICenter: Codable {
    let lat: Double
    let lon: Double
}

struct OSMPOI: Codable {
    let type: OSMNodeType
    let id: Int64
    let lat: Double?
    let lon: Double?
    let center: POICenter?
    let tags: [String: String]?
    
    var icon: String {
        return OSMIconMapper.getOSMFeatureIcon(for: tags ?? [:])
    }
    
}

struct FormBody: FormURLParameters{
    let data: String
}

struct OverpassResponse: Decodable {
    let elements: [OSMPOI]
}


class OverpassAPI {
    private static let overpassNetworkService = OverpassNetworkService.shared
    
    
    static func fetchMapPOIs(mapBounds: MapBounds) async throws -> [OSMPOI]{
        dump("mapBounds input: \(mapBounds)")
        let query = """
        [out:json][timeout:25];
             (
               node["amenity"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["tourism"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["shop"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["leisure"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["highway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["natural"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["building"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["historic"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["emergency"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["healthcare"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["office"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["craft"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["power"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["railway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["aeroway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["aerialway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["military"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["barrier"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["man_made"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["place"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["public_transport"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["telecom"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               node["water"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["amenity"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["tourism"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["shop"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["leisure"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["highway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["natural"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["building"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["historic"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["landuse"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["waterway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["barrier"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["man_made"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["power"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["railway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["aeroway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["aerialway"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["military"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
               way["water"](\(mapBounds.south),\(mapBounds.west),\(mapBounds.north),\(mapBounds.east));
             );
             out center;
        """
        
        do{
            let body = FormBody(data: query)
            let response: OverpassResponse = try await overpassNetworkService.post(
                endpoint: "interpreter",
                body: body,
                requestContentType: .URLEncoded
            )
            return response.elements
        }catch{
            throw(error)
        }
    }
    
}
