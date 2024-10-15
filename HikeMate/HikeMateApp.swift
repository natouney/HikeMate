
// TODO:
/*
 

 - ajouter menu sur le poids total affichant la répartition du poids selon les catégories, et comment il faudrait agencer le sac-à-dos

 
 
   - ne pas pouvoir augmenter la quantité sur certains items (sac, chaussures, casquette...), et ne pas compter dans le poids du sac tous les items (à voir lesquels choisir)
  
   - faire un mode sombre si je m'ennuie


 

 */

import SwiftUI


@main
struct HikeMateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension Color {
    static let GREEN_HIKE = Color(red: 0.22, green: 0.70, blue: 0.41)
    static let GRAY = Color(red: 0.933, green: 0.933, blue: 0.933)
}

// Fonction pour cacher le clavier
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
    @State private var departureTime: String = ""
    @State private var hungerLevel: Double = 1.0
    @State private var numberOfPeople: Int = 1
    @State private var numberOfDays: Int = 1
    @State private var isRavito: Double = 1.0
    
    @State private var newItemName: String = ""
    @State private var newItemWeight: String = ""
    @State private var selectedCategory: String = "Autre"
    @State private var expandedCategories: Set<String> = []
    
    @State private var categories: [Category] = [
        Category(id: UUID(), name: "Nourriture", items: [
                    Item(id: UUID(), name: "Semoule", checked: false, weight: 75, category: "Nourriture"),
                    Item(id: UUID(), name: "Fruits secs", checked: false, weight: 80, category: "Nourriture"),
                    Item(id: UUID(), name: "Galettes de riz", checked: false, weight: 60, category: "Nourriture"),
                    Item(id: UUID(), name: "Chocolat", checked: false, weight: 50, category: "Nourriture"),
                    Item(id: UUID(), name: "Amandes", checked: false, weight: 80, category: "Nourriture"),
                    Item(id: UUID(), name: "Cranberries", checked: false, weight: 20, category: "Nourriture"),
                    Item(id: UUID(), name: "Dattes", checked: false, weight: 90, category: "Nourriture"),
                    Item(id: UUID(), name: "Épinards", checked: false, weight: 50, category: "Nourriture"),
                    Item(id: UUID(), name: "Fromage", checked: false, weight: 90, category: "Nourriture"),
                    Item(id: UUID(), name: "Thé", checked: false, weight: 2, category: "Nourriture"),
                    Item(id: UUID(), name: "Sucre", checked: false, weight: 5, category: "Nourriture"),
                    Item(id: UUID(), name: "Sel", checked: false, weight: 1, category: "Nourriture"),
                    
                ]),
        Category(id: UUID(), name: "Équipement de randonnée", items: [
            Item(id: UUID(), name: "Chaussures", checked: false, weight: 1400, category: "Équipement"),
        ]),
        Category(id: UUID(), name: "Équipement de bivouac", items: []),
        Category(id: UUID(), name: "Vêtements", items: []),
        Category(id: UUID(), name: "Autre", items: [])
    ]

    var body: some View {
        NavigationView {
            VStack {
                HeaderView()

                ScrollView {
                    VStack(spacing: 20) {
                        TripDetailsView(
                            departureTime: $departureTime,
                            hungerLevel: $hungerLevel,
                            numberOfPeople: $numberOfPeople,
                            numberOfDays: $numberOfDays,
                            isRavito: $isRavito
                        )
                        .onAppear {
                            loadCurrentTripDetails()
                        }

                        PackingListView(
                            categories: $categories,
                            newItemName: $newItemName,
                            newItemWeight: $newItemWeight,
                            selectedCategory: $selectedCategory,
                            expandedCategories: $expandedCategories,
                            numberOfPeople: $numberOfPeople,
                            numberOfDays: $numberOfDays,
                            hungerLevel: $hungerLevel,
                            isRavito: $isRavito
                        )
                    }
                    .padding()
                }

                FooterView(totalWeight: Int(calculateTotalWeight(forDays: numberOfDays, people: numberOfPeople, hungry: hungerLevel, isRavito: isRavito)))
            }
            .background(LinearGradient(gradient: Gradient(colors: [.green.opacity(0.2), .blue.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                if let loadedCategories = loadCategoriesFromUserDefaults() {
                    categories = loadedCategories
                }
            }
        }
        
    }

    private func calculateTotalWeight(forDays days: Int, people: Int, hungry: Double, isRavito: Double) -> Double {
        var totalWeight: Double = 0

        for category in categories {
            var categoryTotal: Double = 0

            for item in category.items {
                if item.checked {
                    if category.name == "Nourriture" {
                        // Calculer le poids total pour la nourriture
                        let itemWeight = Double(item.weight) * Double(days) * Double(people) * hungry * isRavito
                        categoryTotal += itemWeight
                    } else {
                        // Calculer le poids total pour les autres catégories
                        categoryTotal += Double(item.weight)
                    }
                }
            }
            totalWeight += categoryTotal
        }

        return totalWeight
    }
    
    func loadCurrentTripDetails() {
        let savedTripDetails = loadTripDetails()
        hungerLevel = savedTripDetails.hungerLevel
        numberOfPeople = savedTripDetails.numberOfPeople
        numberOfDays = savedTripDetails.numberOfDays
        isRavito = savedTripDetails.isRavito
        departureTime = savedTripDetails.departureTime
    }


}

#Preview {
    ContentView()
}
