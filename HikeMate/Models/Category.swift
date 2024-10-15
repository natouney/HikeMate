
import Foundation

struct Item: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var checked: Bool
    var weight: Int
    var category: String
    func quantity(forDays days: Int, people: Int) -> Int {
        return weight * days * people
    }
}

struct Category: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var items: [Item]
}
