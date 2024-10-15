
import Foundation

// Fonction pour sauvegarder les catégories dans UserDefaults
func saveCategoriesToUserDefaults(categories: [Category]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(categories) {
        UserDefaults.standard.set(encoded, forKey: "SavedCategories")
    }
}

func saveTripDetails(hungerLevel: Double, numberOfPeople: Int, numberOfDays: Int, isRavito: Double, departureTime: String) {
    UserDefaults.standard.set(hungerLevel, forKey: "hungerLevel")
    UserDefaults.standard.set(numberOfPeople, forKey: "numberOfPeople")
    UserDefaults.standard.set(numberOfDays, forKey: "numberOfDays")
    UserDefaults.standard.set(isRavito, forKey: "isRavito")
    UserDefaults.standard.set(departureTime, forKey: "departureTime")
}


// Fonction pour charger les catégories depuis UserDefaults
func loadCategoriesFromUserDefaults() -> [Category]? {
    if let savedCategories = UserDefaults.standard.data(forKey: "SavedCategories") {
        let decoder = JSONDecoder()
        if let loadedCategories = try? decoder.decode([Category].self, from: savedCategories) {
            return loadedCategories
        }
    }
    return nil
}

func loadTripDetails() -> (hungerLevel: Double, numberOfPeople: Int, numberOfDays: Int, isRavito: Double, departureTime: String) {
    let hungerLevel = UserDefaults.standard.double(forKey: "hungerLevel")
    let numberOfPeople = UserDefaults.standard.integer(forKey: "numberOfPeople")
    let numberOfDays = UserDefaults.standard.integer(forKey: "numberOfDays")
    let isRavito = UserDefaults.standard.double(forKey: "isRavito")
    let departureTime = UserDefaults.standard.string(forKey: "departureTime") ?? ""
    
    return (hungerLevel == 0.0 ? 1.0 : hungerLevel,
            numberOfPeople == 0 ? 1 : numberOfPeople,
            numberOfDays == 0 ? 1 : numberOfDays,
            isRavito == 0.0 ? 1.0 : isRavito,
            departureTime)
}
