//
//  CareHistoryView.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//

import SwiftUI

struct CareHistoryView: View {
    let stay: PetStay
    let records: [CareActivityRecord]

    var body: some View {
        let sortedRecords = records
            .filter { $0.petStayID == stay.id }
            .sorted { $0.completedAt > $1.completedAt }

        List {
            Section("Care History") {
                if sortedRecords.isEmpty {
                    Text("No completed care activities yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(sortedRecords) { record in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.taskType.rawValue)
                                .font(.headline)

                            Text(
                                record.completedAt.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                            .font(.subheadline)

                            Text("Completed by \(record.completedBy.name)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if let notes = record.notes {
                                Text(notes)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("\(stay.pet.name)'s History")
    }
}

#Preview {
    NavigationStack {
        CareHistoryView(
            stay: MockPetHotelData.miloStay,
            records: MockPetHotelData.careHistory
        )
    }
}
