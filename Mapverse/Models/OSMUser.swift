import Foundation

struct OSMUser: Codable{
    let id: Int
    let displayName: String
    let accountCreated: String
    let description: String?
    let contributionsCount: Int
    let changesets: Changesets
    let blocks: Blocks
    let languagues: [String]
    let messages: Messages
}

struct Changesets: Codable{
    let count: Int
    enum CodingKeys: String, CodingKey {
        case count
    }
}

struct Blocks: Codable{
    let received: Received
    let issued: Int
    
    struct Received: Codable{
        let count: Int
        let active: Int
    }
}

struct Messages: Codable{
    let received: Int
    let sent: Int
    let unread: Int
}

extension OSMUser {
    var formattedAccountCreationDate: String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateformatter.date(from: accountCreated) else {
            return accountCreated
        }
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .none
        return dateformatter.string(from: date)
    }
    var isActiveContributer: Bool{
        return changesets.count > 0
    }
}
