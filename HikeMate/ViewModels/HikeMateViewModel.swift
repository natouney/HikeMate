
import SwiftUI

class HikeMateViewModel: ObservableObject {
    @Published var tripDetails = TripDetails(departureTime: "", hungerLevel: "medium", numberOfPeople: 1, numberOfDays: 1)

    @Published var categories: [Category] = [
        Category(name: "Food", items: []),
        Category(name: "Hiking Gear", items: []),
        Category(name: "Clothing", items: []),
        Category(name: "Other", items: [])
    ]
    
    @Published var newItem = Item(name: "", checked: false, weight: 0.0, category: "Other", quantity: 1)
    @Published var expandedCategory: String? = nil

    let defaultFoodMenu: [Item] = [
        Item(name: "Energy bar", checked: false, weight: 50, category: "Food", quantity: 2),
        Item(name: "Trail mix", checked: false, weight: 100, category: "Food", quantity: 1),
        Item(name: "Dried fruits", checked: false, weight: 50, category: "Food", quantity: 1),
        // Ajoutez les autres éléments ici
    ]

    func updateFoodItems() {
        let hungerScaleFactor: Double = {
            switch tripDetails.hungerLevel {
            case "low": return 0.8
            case "high": return 1.2
            default: return 1.0
            }
        }()

        let scaledFoodItems = defaultFoodMenu.map { item -> Item in
            var newItem = item
            newItem.quantity = Int(Double(item.quantity) * hungerScaleFactor * Double(tripDetails.numberOfDays) * Double(tripDetails.numberOfPeople))
            return newItem
        }

        if let foodCategoryIndex = categories.firstIndex(where: { $0.name == "Food" }) {
            categories[foodCategoryIndex].items = scaledFoodItems
        }
    }

    func addItem() {
        if !newItem.name.isEmpty {
            if let categoryIndex = categories.firstIndex(where: { $0.name == newItem.category }) {
                categories[categoryIndex].items.append(newItem)
                newItem = Item(name: "", checked: false, weight: 0.0, category: "Other", quantity: 1)
            }
        }
    }

    func toggleItem(categoryName: String, id: UUID) {
        if let categoryIndex = categories.firstIndex(where: { $0.name == categoryName }),
           let itemIndex = categories[categoryIndex].items.firstIndex(where: { $0.id == id }) {
            categories[categoryIndex].items[itemIndex].checked.toggle()
        }
    }

    func removeItem(categoryName: String, id: UUID) {
        if let categoryIndex = categories.firstIndex(where: { $0.name == categoryName }) {
            categories[categoryIndex].items.removeAll(where: { $0.id == id })
        }
    }

    func updateItemQuantity(categoryName: String, id: UUID, newQuantity: Int) {
        if let categoryIndex = categories.firstIndex(where: { $0.name == categoryName }),
           let itemIndex = categories[categoryIndex].items.firstIndex(where: { $0.id == id }) {
            categories[categoryIndex].items[itemIndex].quantity = newQuantity
        }
    }

    func calculateTotalWeight() -> Double {
        return categories.reduce(0) { total, category in
            total + category.items.reduce(0) { catTotal, item in
                catTotal + (item.checked ? item.weight * Double(item.quantity) : 0)
            }
        }
    }
}
