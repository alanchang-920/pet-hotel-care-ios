//
//  DailyCareTasksViewModel.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/12.
//
import Foundation
import Observation

/// Manages the daily care workflow for a pet currently staying at the hotel.
///
/// The view model prepares the selected pet's care plan and coordinates
/// care task completion and medication administration through domain use cases.
@Observable
final class DailyCareTasksViewModel {

    var tasks: [CareTask]
    var errorMessage: String?

    private let stay: PetStay

    private let completeCareTaskUseCase = CompleteCareTaskUseCase()
    private let recordMedicationUseCase = RecordMedicationAdministrationUseCase()

    init(
        stay: PetStay,
        careHistory: [CareActivityRecord]
    ) {
        self.stay = stay

        let reviewUseCase = ReviewDailyCarePlanUseCase()

        var careTasks = reviewUseCase.execute(
            petStayID: stay.id,
            tasks: MockPetHotelData.careTasks
        )

        for index in careTasks.indices {
            let taskWasCompleted = careHistory.contains {
                $0.petStayID == stay.id &&
                $0.careTaskID == careTasks[index].id
            }

            if taskWasCompleted {
                careTasks[index].isCompleted = true
            }
        }

        self.tasks = careTasks
    }

    func completeTask(
        at index: Int,
        careHistory: inout [CareActivityRecord]
    ) {
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

    func recordMedication(
        at index: Int,
        careHistory: inout [CareActivityRecord]
    ) {
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
