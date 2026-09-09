//
//  PetStayDetailView.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//

import SwiftUI

struct PetStayDetailView: View {
    let stay: PetStay
    
    @State private var careHistory: [CareActivityRecord]
    
    init(stay: PetStay) {
            self.stay = stay

            let history = MockPetHotelData.careHistory
                .filter { $0.petStayID == stay.id }

            _careHistory = State(initialValue: history)
        }

    var body: some View {
        List {
            Section("Pet") {
                Text(stay.pet.name)
                    .font(.headline)

                Text(stay.pet.breed)

                Text(stay.pet.species.rawValue)
            }

            Section("Stay Details") {
                Text("Room \(stay.roomNumber)")
                Text("Check-in: \(stay.checkInDate.formatted(date: .abbreviated, time: .omitted))")
                Text("Check-out: \(stay.checkOutDate.formatted(date: .abbreviated, time: .omitted))")
            }

            Section("Feeding Instructions") {
                Text(stay.feedingInstructions)
            }

            Section("Care Notes") {
                Text(stay.careNotes)
            }
            
            Section {
                NavigationLink {
                    DailyCareTasksView(
                            stay: stay,
                            careHistory: $careHistory
                        )
                } label: {
                    Text("View Today's Care Tasks")
                }

                NavigationLink {
                    CareHistoryView(
                            stay: stay,
                            records: careHistory
                        )
                } label: {
                    Text("View Care History")
                }
            }
        }
        .navigationTitle(stay.pet.name)
    }
}

#Preview {
    NavigationStack {
        PetStayDetailView(
            stay: MockPetHotelData.miloStay
        )
    }
}
