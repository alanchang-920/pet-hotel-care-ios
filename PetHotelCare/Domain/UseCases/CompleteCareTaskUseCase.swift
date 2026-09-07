//
//  CompleteCareTaskUseCase.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//
import Foundation

/// Handles completion of a care task.
///
/// A care task may only be completed once. When successfully completed,
/// the use case updates the task and creates a care activity record
/// identifying when and by whom the care was provided.
struct CompleteCareTaskUseCase {

    func execute(
        task: inout CareTask,
        staff: StaffMember,
        completedAt: Date,
        notes: String? = nil
    ) throws -> CareActivityRecord {

        // Prevent the same care task from being completed more than once.
        guard !task.isCompleted else {
            throw PetHotelError.taskAlreadyCompleted
        }

        // Mark the task as completed.
        task.isCompleted = true

        // Create an audit record of the completed care activity.
        return CareActivityRecord(
            id: UUID(),
            petStayID: task.petStayID,
            careTaskID: task.id,
            taskType: task.type,
            completedAt: completedAt,
            completedBy: staff,
            notes: notes
        )
    }
}
