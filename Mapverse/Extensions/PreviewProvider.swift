import Foundation
import SwiftUI

extension PreviewProvider{
    static var dev: DeveloperPreview{
        return DeveloperPreview.shared
    }
}

class DeveloperPreview{
     
    static let shared = DeveloperPreview()
    
    let showNodeInfoBottomSheet = true
    let selectedPOIAttributes = MapFeatureAttributes(from: [
        "poiId": NSNumber(value: 123456789),
        "poiType": "node",
        "iconId": "restaurant",
        "tags": [
            "amenity": "restaurant",
            "name": "The Local Cafe",
            "cuisine": "italian",
            "opening_hours": "Mo-Su 08:00-22:00",
            "phone": "+1234567890",
            "website": "https://thelocalcafe.com",
            "addr:street": "123 Main Street",
            "addr:city": "San Francisco",
            "addr:postcode": "94102"
        ] as NSDictionary
    ])
    
    let selectedPOIOSMInfo = OSMPOIInfoResponse(
        version: "0.6",
        generator: "Overpass API",
        copyright: "The data included in this document is from www.openstreetmap.org. The data is made available under ODbL.",
        attribution: "© OpenStreetMap contributors",
        license: "http://www.opendatacommons.org/licenses/odbl/1.0/",
        elements: [
            OSMPOIInfo(
                type: .node,
                id: 123456789,
                lat: 37.7749,
                lon: -122.4194,
                timestamp: "2024-06-25T14:30:00Z",
                tags: [
                    "amenity": "restaurant",
                    "name": "The Local Cafe",
                    "cuisine": "italian",
                    "opening_hours": "Mo-Su 08:00-22:00",
                    "phone": "+1234567890",
                    "website": "https://thelocalcafe.com",
                    "addr:street": "123 Main Street",
                    "addr:city": "San Francisco",
                    "addr:postcode": "94102"
                ],
                version: 3,
                changeset: 987654321,
                user: "mapverse_user",
                uid: 555444333,
                nodes: nil
            )
        ]
    )
}
