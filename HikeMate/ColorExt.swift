import SwiftUI

extension Color {
    init?(hex: String) {
        var rgb: UInt64 = 0

        // Vérifie que la chaîne commence par '#'
        guard hex.hasPrefix("#") else {
            return nil
        }

        // Enlève le '#' et convertit la chaîne en un nombre hexadécimal
        let hexString = String(hex.dropFirst())
        
        // Vérifie la longueur de la chaîne hexadécimale
        guard hexString.count == 6, Scanner(string: hexString).scanHexInt64(&rgb) else {
            return nil
        }

        // Extrait les valeurs rouge, verte et bleue
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
