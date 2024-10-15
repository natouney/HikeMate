
import SwiftUI

struct TripDetailsView: View {
    @Binding var departureTime: String
    @Binding var hungerLevel: Double
    @Binding var numberOfPeople: Int
    @Binding var numberOfDays: Int
    @Binding var isRavito: Double

    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Trip Details")
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                
                HStack {
                    GeometryReader { geometry in
                        Text("Nombre de personnes")
                        .frame(width: geometry.size.width * 1.2, height: geometry.size.height, alignment: .leading)
                            .lineLimit(1)
                    }
                    
                    Stepper(value: $numberOfPeople, in: 1...20, onEditingChanged: { _ in
                        saveCurrentTripDetails()
                    }) {
                        Text("\(numberOfPeople)")
                            .frame(width: 50, alignment: .trailing)
                    }
                }

                HStack {
                    GeometryReader { geometry in
                        Text("Nombre de jours")
                        .frame(width: geometry.size.width * 1.2, height: geometry.size.height, alignment: .leading)
                            .lineLimit(1)
                    }
                    
                    Stepper(value: $numberOfDays, in: 1...30, onEditingChanged: { _ in
                        saveCurrentTripDetails()
                    }) {
                        Text("\(numberOfDays) j")
                            .frame(width: 50, alignment: .trailing)
                    }

                }
                
                HStack {
                    Text("Faim habituelle : ")
                    
                    Spacer()
                    
                    Picker("Select Hunger Level", selection: $hungerLevel) {
                        Text("Petite").tag(0.85)
                        Text("Normale").tag(1.0)
                        Text("Grande").tag(1.15)
                        Text("Très grande").tag(1.3)
                        Text("Énorme").tag(1.5)
                    }
                    .onChange(of: hungerLevel) { oldValue, newValue in
                        saveCurrentTripDetails()
                    }
                    .background(Color.GRAY)
                    .cornerRadius(8.0)
                    .accentColor(.black)
                }
                
                VStack {
                    Text("Ravitaillement possible ?")
                    Picker("Ravitaillement", selection: $isRavito) {
                        Text("Oui").tag(1.0)
                        Text("Non").tag(1.1)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: isRavito) { oldValue, newValue in
                        saveCurrentTripDetails()
                    }
                }
                .padding(.bottom)
                
                HStack {
                    Text("Departure Time")
                    TextField("12:30", text: $departureTime, onCommit: {
                        saveCurrentTripDetails()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numbersAndPunctuation)
                }
                // Peut-être ajouter une option en fonction de l'heure, penser à prendre certains matériel
                
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        
    }
    
    func saveCurrentTripDetails() {
        saveTripDetails(hungerLevel: hungerLevel,
                        numberOfPeople: numberOfPeople,
                        numberOfDays: numberOfDays,
                        isRavito: isRavito,
                        departureTime: departureTime)
    }
}

#Preview {
    ContentView()
}
