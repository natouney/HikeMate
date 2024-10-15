import SwiftUI

struct RecommendationsView: View {
    var totalWeight: Double
    
    var body: some View {
        VStack {
            Text("Recommandations d'organisation")
                .font(.title)
                .padding()
            
            // Exemple de recommandations
            if totalWeight > 2000 { // 2 kg
                Text("Votre sac est trop lourd ! Envisagez de retirer quelques articles.")
            } else if totalWeight < 1000 { // 1 kg
                Text("Vous pouvez ajouter plus d'équipement.")
            } else {
                Text("Le poids de votre sac est optimal.")
            }
            
            Spacer()
        }
        .padding()
    }
}
