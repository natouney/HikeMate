import SwiftUI

struct PackingListView: View {
    @Binding var categories: [Category]
    @Binding var newItemName: String
    @Binding var newItemWeight: String
    @Binding var selectedCategory: String
    @Binding var expandedCategories: Set<String>
    
    @Binding var numberOfPeople: Int
    @Binding var numberOfDays: Int
    @Binding var hungerLevel: Double
    @Binding var isRavito: Double

    @State private var showCheckmark = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Packing List")
                .font(.title)
                .bold()

            // New Item Input Section
            VStack {
                InputItemView(newItemName: $newItemName, newItemWeight: $newItemWeight, categories: $categories, selectedCategory: $selectedCategory, showCheckmark: $showCheckmark, addItemAction: addItem)
            }
            .padding(.bottom)

            // List of Categories and Items
            ForEach(categories) { category in
                CategoryItemView(category: category, expandedCategories: $expandedCategories, categories: $categories, numberOfDays: numberOfDays, numberOfPeople: numberOfPeople, hungerLevel: hungerLevel, isRavito: isRavito, toggleItemAction: toggleItem, calculateTotalWeightAction: calculateTotalWeight)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .animation(.easeInOut(duration: 0.3), value: expandedCategories)

    }

    // Add a new item to the selected category
    private func addItem() {
        guard !newItemName.isEmpty, let weight = Double(newItemWeight) else { return }
        if let categoryIndex = categories.firstIndex(where: { $0.name == selectedCategory }) {
            categories[categoryIndex].items.append(Item(id: UUID(), name: newItemName, checked: false, weight: Int(weight), category: selectedCategory))
            newItemName = ""
            newItemWeight = ""
            
            showCheckmark = true // Affiche le checkmark
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showCheckmark = false // Masquer le checkmark après 1 seconde
            }
        }
    }
    
    private func toggleItem(categoryName: String, id: UUID) {
        if let categoryIndex = categories.firstIndex(where: { $0.name == categoryName }) {
            if let itemIndex = categories[categoryIndex].items.firstIndex(where: { $0.id == id }) {
                categories[categoryIndex].items[itemIndex].checked.toggle()
            }
        }
    }

    private func calculateTotalWeight(for item: Item) -> Double {
        let itemWeight = item.weight
        if let category = categories.first(where: { $0.items.contains(where: { $0.id == item.id }) }) {
            if category.name == "Nourriture" {
                let portions = Double(numberOfDays) * Double(numberOfPeople)
                let hungry = hungerLevel * isRavito
                return Double(itemWeight) * portions * hungry
            } else {
                return Double(itemWeight)
            }
        }
        return 0.0
    }
}

#Preview {
    ContentView()
}
