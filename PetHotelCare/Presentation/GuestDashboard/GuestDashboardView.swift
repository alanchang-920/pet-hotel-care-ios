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
                            VStack(alignment: .leading, spacing: 6) {
                                Text(stay.pet.name)
                                    .font(.headline)

                                Text(stay.pet.breed)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)

                                Text("Room \(stay.roomNumber)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Pet Hotel")
        }
    }
}

#Preview {
    GuestDashboardView()
}
