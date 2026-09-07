//
//  CompleteCareTaskUseCaseTests.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//
import Foundation
import Testing
@testable import PetHotelCare

struct CompleteCareTaskUseCaseTests {

    @Test
    func completesPendingCareTaskSuccessfully() throws {
        var task = CareTask(
            id: UUID(),
            petStayID: UUID(),
            type: .feeding,
            scheduledTime: Date(),
            instructions: "Give 1 cup of dry food.",
            isCompleted: false
        )

        let staff = StaffMember(
            id: UUID(),
            name: "Emma"
        )

        let completedAt = Date()
        let useCase = CompleteCareTaskUseCase()

        let record = try useCase.execute(
            task: &task,
            staff: staff,
            completedAt: completedAt,
            notes: "Ate all food."
        )

        #expect(task.isCompleted == true)
        #expect(record.careTaskID == task.id)
        #expect(record.completedBy.id == staff.id)
        #expect(record.completedAt == completedAt)
        #expect(record.notes == "Ate all food.")
    }
    
    @Test
    func cannotCompleteAlreadyCompletedTask() {
        var task = CareTask(
            id: UUID(),
            petStayID: UUID(),
            type: .walking,
            scheduledTime: Date(),
            instructions: "Take the pet for a walk.",
            isCompleted: true
        )

        let staff = StaffMember(
            id: UUID(),
            name: "Emma"
        )

        let useCase = CompleteCareTaskUseCase()

        #expect(throws: PetHotelError.taskAlreadyCompleted) {
            try useCase.execute(
                task: &task,
                staff: staff,
                completedAt: Date()
            )
        }
    }
}
