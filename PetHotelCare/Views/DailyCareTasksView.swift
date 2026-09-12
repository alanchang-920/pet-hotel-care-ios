//
//  DailyCareTasksView.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//

import SwiftUI

struct DailyCareTasksView: View {
    let stay: PetStay

    @Binding var careHistory: [CareActivityRecord]
    @State private var viewModel: DailyCareTasksViewModel

    init(
        stay: PetStay,
        careHistory: Binding<[CareActivityRecord]>
    ) {
        self.stay = stay
        self._careHistory = careHistory

        _viewModel = State(
            initialValue: DailyCareTasksViewModel(
                stay: stay,
                careHistory: careHistory.wrappedValue
            )
        )
    }

    var body: some View {
        List {
            Section("Today's Care") {
                if viewModel.tasks.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "checklist")
                            .font(.title2)
                            .foregroundStyle(.secondary)

                        Text("No care tasks scheduled for today.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)

                } else {
                    ForEach(viewModel.tasks.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .top) {
                                Label(
                                    viewModel.tasks[index].type.rawValue,
                                    systemImage: taskIcon(
                                        for: viewModel.tasks[index].type
                                    )
                                )
                                .font(.headline)

                                Spacer()

                                Text(
                                    viewModel.tasks[index].isCompleted
                                        ? "Completed"
                                        : "Pending"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Text(viewModel.tasks[index].instructions)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Label(
                                viewModel.tasks[index].scheduledTime.formatted(
                                    date: .omitted,
                                    time: .shortened
                                ),
                                systemImage: "clock"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            if !viewModel.tasks[index].isCompleted {
                                if viewModel.tasks[index].type == .medication {
                                    Button {
                                        viewModel.recordMedication(
                                            at: index,
                                            careHistory: &careHistory
                                        )
                                    } label: {
                                        Label(
                                            "Record Medication",
                                            systemImage: "pills.fill"
                                        )
                                    }

                                } else {
                                    Button {
                                        viewModel.completeTask(
                                            at: index,
                                            careHistory: &careHistory
                                        )
                                    } label: {
                                        Label(
                                            "Mark Completed",
                                            systemImage: "checkmark.circle"
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
        }
        .navigationTitle("\(stay.pet.name)'s Care")
        .alert(
            "Unable to Complete Task",
            isPresented: Binding(
                get: {
                    viewModel.errorMessage != nil
                },
                set: { newValue in
                    if !newValue {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
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
        DailyCareTasksView(
            stay: MockPetHotelData.miloStay,
            careHistory: .constant(MockPetHotelData.careHistory)
        )
    }
}
