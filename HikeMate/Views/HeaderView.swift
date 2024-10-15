
import SwiftUI
import SVGKit



struct HeaderView: View {
    var body: some View {
        HStack {
            HStack {
                // Chargez l'image SVG
                if let svgImage = SVGKImage(named: "mountain.svg") {
                    // Vérifiez si l'UIImage est disponible
                    if let uiImage = svgImage.uiImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 50, height: 50) // Ajustez la taille
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Text("Image non trouvéeee")
                            .foregroundColor(.blue)
                    }
                } else {
                    Text("Image non trouvée")
                        .foregroundColor(.red)
                }

                VStack {
                    Text("HikeMate")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading) // Aligne ce texte à gauche


                    Text("Your Hiking Companion")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading) // Aligne ce texte à gauche

                }
                .padding(.leading)
                
            }
            Spacer()
        }
        .padding()
        .background(Color.GREEN_HIKE)
        .foregroundColor(.white)
    }
}

#Preview {
    ContentView()
}
