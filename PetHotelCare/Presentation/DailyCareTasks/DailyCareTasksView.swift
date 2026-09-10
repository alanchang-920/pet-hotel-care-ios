//
//  DailyCareTasksView.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//

import SwiftUI

struct DailyCareTasksView: View {
    let stay: PetStay

    @State private var tasks: [CareTask]
    @Binding var careHistory: [CareActivityRecord]
    @State private var errorMessage: String?

    private let completeCareTaskUseCase = CompleteCareTaskUseCase()
    private let recordMedicationUseCase = RecordMedicationAdministrationUseCase()

    init(
        stay: PetStay,
        careHistory: Binding<[CareActivityRecord]>
    ) {
        self.stay = stay
        self._careHistory = careHistory

        let reviewUseCase = ReviewDailyCarePlanUseCase()

        var careTasks = reviewUseCase.execute(
            petStayID: stay.id,
            tasks: MockPetHotelData.careTasks
        )

        for index in careTasks.indices {
            let taskWasCompleted = careHistory.wrappedValue.contains {
                $0.petStayID == stay.id &&
                $0.careTaskID == careTasks[index].id
            }

            if taskWasCompleted {
                careTasks[index].isCompleted = true
            }
        }

        _tasks = State(initialValue: careTasks)
    }

    var body: some View {
        List {
            Section("Today's Care") {
                if tasks.isEmpty {
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
                    ForEach(tasks.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 10) {

                            HStack(alignment: .top) {
                                Label(
                                    tasks[index].type.rawValue,
                                    systemImage: taskIcon(for: tasks[index].type)
                                )
                                .font(.headline)

                                Spacer()

                                Text(
                                    tasks[index].isCompleted
                                    ? "Completed"
                                    : "Pending"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Text(tasks[index].instructions)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Label(
                                tasks[index].scheduledTime.formatted(
                                    date: .omitted,
                                    time: .shortened
                                ),
                                systemImage: "clock"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            if !tasks[index].isCompleted {
                                if tasks[index].type == .medication {
                                    Button {
                                        recordMedication(at: index)
                                    } label: {
                                        Label(
                                            "Record Medication",
                                            systemImage: "pills.fill"
                                        )
                                    }
                                } else {
                                    Button {
                                        completeTask(at: index)
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
                get: { errorMessage != nil },
                set: { newValue in
                    if !newValue {
                        errorMessage = nil
                    }
                }
            )
        ) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            Text(errorMessage ?? "")
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

    private func completeTask(at index: Int) {
        do {
            let record = try completeCareTaskUseCase.execute(
                task: &tasks[index],
                staff: MockPetHotelData.currentStaff,
                completedAt: Date()
            )

            careHistory.append(record)

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func recordMedication(at index: Int) {
        guard tasks[index].type == .medication else {
            return
        }

        let previousMedicationRecord = careHistory
            .filter {
                $0.petStayID == stay.id &&
                $0.taskType == .medication
            }
            .sorted {
                $0.completedAt > $1.completedAt
            }
            .first

        do {
            let record = try recordMedicationUseCase.execute(
                schedule: MockPetHotelData.miloMedication,
                careTaskID: tasks[index].id,
                previousAdministration: previousMedicationRecord,
                staff: MockPetHotelData.currentStaff,
                administeredAt: Date()
            )

            tasks[index].isCompleted = true
            careHistory.append(record)

        } catch {
            errorMessage = error.localizedDescription
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
