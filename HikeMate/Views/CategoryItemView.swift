
import SwiftUI
import UIKit


struct CategoryItemView: View {
    var category: Category
    @Binding var expandedCategories: Set<String>
    @Binding var categories: [Category]
    
    var numberOfDays: Int
    var numberOfPeople: Int
    var hungerLevel: Double
    var isRavito: Double

    var toggleItemAction: (String, UUID) -> Void
    var calculateTotalWeightAction: (Item) -> Double

    var body: some View {
        VStack {
            HStack {
                // "Check/Uncheck All" Button
                Button(action: {
                    if !category.items.isEmpty {
                        toggleAllItems(in: category)
                    }
                }) {
                    Image(systemName: category.items.isEmpty ? "circle" : allItemsChecked(in: category) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(category.items.isEmpty ? Color(.systemGray3) : allItemsChecked(in: category) ? Color.GREEN_HIKE : .gray)
                        .transition(.scale)  // Add a transition for smooth animation
                        .animation(.easeInOut(duration: 0.3), value: allItemsChecked(in: category))  // Ensure animation is applied to both states
                }
                .disabled(category.items.isEmpty)

                Button(action: {
                    toggleCategory()
                }) {
                    HStack {
                        let allItemsChecked = category.items.allSatisfy { item in
                            item.checked
                        }
                        let isCategoryEmpty = category.items.isEmpty

                        Text(category.name + (category.name != "Nourriture" ? "" : numberOfDays * numberOfPeople > 1 ? " (\(numberOfDays * numberOfPeople) portions)" : " (\(numberOfDays * numberOfPeople) portion)"))
                            .font(.headline)
                            .foregroundStyle(isCategoryEmpty ? Color(.systemGray3) : allItemsChecked ? Color.GREEN_HIKE : .black)
                            .transition(.slide)
                            .animation(.easeInOut(duration: 0.4), value: allItemsChecked)
                        
                        Spacer()
                        
                        let rotation: Double = expandedCategories.contains(category.name) ? 0 : 180

                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(rotation))
                            .animation(.easeInOut(duration: 0.3), value: rotation)
                            .accentColor(isCategoryEmpty ? Color(.systemGray3) : .black)
                    }
                }
            }
            

            if expandedCategories.contains(category.name) {
                VStack {
                    ForEach(category.items) { item in
                        HStack {
                            Button(action: {
                                toggleItem(categoryName: category.name, id: item.id)
                            }) {
                                Image(systemName: item.checked ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.checked ? .green : .gray)
                                    .transition(.scale)  // Add a transition for smooth animation
                                    .animation(.easeInOut(duration: 0.3), value: item.checked)  // Ensure animation is applied to both states


                                // Calculer la quantité totale (poids en grammes)
                                let totalWeight = calculateTotalWeight(for: item)

                                // Afficher le nom de l'item, le poids total et les portions
                                Text("\(item.name) (\(totalWeight, specifier: "%.0f")g)")
                                    .strikethrough(item.checked, color: .gray)
                                    .foregroundColor(item.checked ? .gray : .black)
                                    .animation(.easeInOut(duration: 0.2), value: item.checked)
                                    .padding(10)
                            }

                            Spacer()
                                                                
                            Button(action: {
                                withAnimation {
                                    removeItem(categoryName: category.name, id: item.id)
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(item.checked ? .gray : .red)
                            }
                            .disabled(item.checked)
                        }
                        .transition(.asymmetric(insertion: .scale, removal: .slide.combined(with: .opacity)))

                    }
                }
                .transition(.opacity)
                
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .animation(.easeInOut(duration: 0.3), value: expandedCategories)
    }
    
    private func toggleCategory() {
        withAnimation {
            if expandedCategories.contains(category.name) {
                expandedCategories.remove(category.name)
            } else if !category.items.isEmpty {
                expandedCategories.insert(category.name)
            }
        }
    }
    
    private func toggleAllItems(in category: Category) {
        if let categoryIndex = categories.firstIndex(where: { $0.name == category.name }) {
            let allChecked = allItemsChecked(in: category)
            categories[categoryIndex].items.indices.forEach { index in
                categories[categoryIndex].items[index].checked = !allChecked
            }
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            
            saveCategoriesToUserDefaults(categories: categories)
        }
    }
    
    private func allItemsChecked(in category: Category) -> Bool {
        return category.items.allSatisfy { $0.checked }
    }

    
    private func toggleItem(categoryName: String, id: UUID) {
        if let categoryIndex = categories.firstIndex(where: { $0.name == categoryName }) {
            if let itemIndex = categories[categoryIndex].items.firstIndex(where: { $0.id == id }) {
                categories[categoryIndex].items[itemIndex].checked.toggle()

                // Créer un générateur de retour haptique
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
                
                saveCategoriesToUserDefaults(categories: categories)
            }
        }
    }

    // Function to calculate total weight
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
    
    private func removeItem(categoryName: String, id: UUID) {
        if let categoryIndex = categories.firstIndex(where: { $0.name == categoryName }) {
            if let itemIndex = categories[categoryIndex].items.firstIndex(where: { $0.id == id }) {
                // Supprimer l'item
                categories[categoryIndex].items.remove(at: itemIndex)
                
                // Si la catégorie est vide après suppression, la retirer de expandedCategories
                if categories[categoryIndex].items.isEmpty {
                    expandedCategories.remove(categoryName)
                }
                
                saveCategoriesToUserDefaults(categories: categories)
            }
        }
    }


}


#Preview {
    ContentView()
}
