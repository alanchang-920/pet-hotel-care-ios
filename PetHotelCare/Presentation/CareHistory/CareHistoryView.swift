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
                    VStack(spacing: 8) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title2)
                            .foregroundStyle(.secondary)

                        Text("No completed care activities yet.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)

                } else {
                    ForEach(sortedRecords) { record in
                        VStack(alignment: .leading, spacing: 8) {

                            HStack {
                                Label(
                                    record.taskType.rawValue,
                                    systemImage: taskIcon(for: record.taskType)
                                )
                                .font(.headline)

                                Spacer()

                                Text(
                                    record.completedAt.formatted(
                                        date: .abbreviated,
                                        time: .shortened
                                    )
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Label(
                                "Completed by \(record.completedBy.name)",
                                systemImage: "person.fill"
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                            if let notes = record.notes,
                               !notes.isEmpty {
                                Text(notes)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .navigationTitle("\(stay.pet.name)'s History")
    }

    private func taskIcon(for type: CareTaskType) -> String {
        switch type {
        case .feeding:
            return "fork.knife"

        case .walking:
            return "figure.walk"

        case .medication:
            return "pills.fill"
        }
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
