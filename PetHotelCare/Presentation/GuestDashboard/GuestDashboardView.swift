//
//  GuestDashboardView.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//
import SwiftUI

struct GuestDashboardView: View {

    var body: some View {
        NavigationStack {
            List {
                Section("Current Guests") {
                    ForEach(MockPetHotelData.currentStays) { stay in
                        NavigationLink {
                            PetStayDetailView(stay: stay)
                        } label: {
                            HStack(spacing: 12) {

                                Image(systemName: petIcon(for: stay.pet.species))
                                    .font(.title2)
                                    .frame(width: 32)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(stay.pet.name)
                                        .font(.headline)

                                    Text(stay.pet.breed)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    Text("\(stay.pet.species.rawValue) • Room \(stay.roomNumber)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            .navigationTitle("Pet Hotel")
        }
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
    GuestDashboardView()
}
