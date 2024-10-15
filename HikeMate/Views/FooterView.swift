import SwiftUI

struct FooterView: View {
    @State private var animatedTotalWeight: Double = 0.0 // Variable d'état pour le poids animé
    var totalWeight: Int // Poids total d'origine

    var body: some View {
        HStack {
            VStack {
                Text("© 2024 HikeMate.")
                Text("Happy Hiking!")
            }
            Spacer()
            NavigationLink(destination: RecommendationsView(totalWeight: animatedTotalWeight)) {
                Text("Poids total: \(Int(animatedTotalWeight)) g") // Utiliser le poids animé
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
            }
            .onAppear {
                animatedTotalWeight = Double(totalWeight) // Initialiser le poids animé
            }
            .onChange(of: totalWeight) { newValue in
                animateWeightChange(to: Double(newValue)) // Animer lors du changement de totalWeight
            }
        }
        .padding()
        .background(Color.GREEN_HIKE)
        .foregroundColor(.white)
    }

    private func animateWeightChange(to targetWeight: Double) {
        // Si la différence est nulle, ne rien faire
        guard targetWeight != animatedTotalWeight else { return }

        let difference = targetWeight - animatedTotalWeight
        let steps = 25 // Nombre de pas pour l'animation
        let increment = difference / Double(steps)

        // Utilisation de DispatchQueue pour animer en douceur
        for step in 0..<steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * 0.01) {
                animatedTotalWeight += increment
                // Si c'est le dernier pas, assure que le poids final est correct
                if step == steps - 1 {
                    animatedTotalWeight = targetWeight
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
