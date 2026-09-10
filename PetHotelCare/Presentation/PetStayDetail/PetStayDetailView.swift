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
                VStack(alignment: .leading, spacing: 6) {
                    Text(stay.pet.name)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(stay.pet.breed)
                        .foregroundStyle(.secondary)

                    Label(
                        stay.pet.species.rawValue,
                        systemImage: petIcon(for: stay.pet.species)
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Stay Details") {
                LabeledContent("Room") {
                    Text(stay.roomNumber)
                }

                LabeledContent("Check-in") {
                    Text(
                        stay.checkInDate.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                }

                LabeledContent("Check-out") {
                    Text(
                        stay.checkOutDate.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                }
            }

            Section("Feeding Instructions") {
                Text(stay.feedingInstructions)
            }

            Section("Care Notes") {
                Text(stay.careNotes)
            }

            Section("Care Management") {
                NavigationLink {
                    DailyCareTasksView(
                        stay: stay,
                        careHistory: $careHistory
                    )
                } label: {
                    Label(
                        "View Today's Care Tasks",
                        systemImage: "checklist"
                    )
                }

                NavigationLink {
                    CareHistoryView(
                        stay: stay,
                        records: careHistory
                    )
                } label: {
                    Label(
                        "View Care History",
                        systemImage: "clock.arrow.circlepath"
                    )
                }
            }
        }
        .navigationTitle(stay.pet.name)
    }

    private func petIcon(for species: PetSpecies) -> String {
        switch species {
        case .dog:
            return "dog.fill"
        case .cat:
            return "cat.fill"
        }
    }
}

#Preview {
    NavigationStack {
        PetStayDetailView(
            stay: MockPetHotelData.miloStay
        )
    }
}
