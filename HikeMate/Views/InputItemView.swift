
import SwiftUI
import UIKit


struct InputItemView: View {
    @Binding var newItemName: String
    @Binding var newItemWeight: String
    @Binding var categories: [Category]
    @Binding var selectedCategory: String
    @Binding var showCheckmark: Bool

    var addItemAction: () -> Void

    var body: some View {
        VStack {
            TextField("Ajouter un nouvel item...", text: $newItemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
            
            HStack {
                TextField("Poids (g)", text: $newItemWeight)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                Picker("Catégorie", selection: $selectedCategory) {
                    ForEach(categories, id: \.name) { category in
                        Text(displayName(for: category.name)).tag(category.name)
                    }
                }
                .frame(height: 32)
                .fixedSize(horizontal: true, vertical: false)
                .background(Color.GRAY)
                .cornerRadius(8.0)
                .accentColor(.black)
                .pickerStyle(MenuPickerStyle())

                Button(action: {
                    addItem()
                }) {
                    HStack {
                        if showCheckmark {
                            Image(systemName: "checkmark")
                                .accentColor(Color.white)
                                .transition(.scale)
                        } else {
                            Image(systemName: "plus.circle")
                                .accentColor(Color.white)
                            Text("Ajouter")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding(7)
                    .animation(.easeInOut(duration: 0.3), value: showCheckmark)
                }
                .frame(width: 97, height: 32)
                .fixedSize(horizontal: true, vertical: false)
                .background(Color.GREEN_HIKE)
                .cornerRadius(8.0)
            }
        }
        .padding(.bottom)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("OK") {
                    hideKeyboard()
                }
            }
        }
    }
    
    private func addItem() {
        guard !newItemName.isEmpty, let weight = Double(newItemWeight) else { return }
        if let categoryIndex = categories.firstIndex(where: { $0.name == selectedCategory }) {
            categories[categoryIndex].items.append(Item(id: UUID(), name: newItemName, checked: false, weight: Int(weight), category: selectedCategory))
            newItemName = ""
            newItemWeight = ""
            
            showCheckmark = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showCheckmark = false 
            }
            
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                generator.prepare()
                generator.impactOccurred()
            }
            
            saveCategoriesToUserDefaults(categories: categories)
        }
    }
    
    func displayName(for categoryName: String) -> String {
        switch categoryName {
        case "Équipement de bivouac":
            return "Bivouac"
        case "Équipement de randonnée":
            return "Randonnée"
        default:
            return categoryName  // Si le nom de la catégorie ne correspond pas, on affiche le nom d'origine
        }
    }
}

#Preview {
    ContentView()
}
