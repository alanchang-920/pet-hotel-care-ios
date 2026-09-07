//
//  ReviewDailyCarePlanUseCaseTests.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//
import Foundation
import Testing
@testable import PetHotelCare

struct ReviewDailyCarePlanUseCaseTests {

    @Test
    func returnsOnlyTasksForSelectedPetStay() {
        let selectedStayID = UUID()
        let otherStayID = UUID()

        let selectedTask = CareTask(
            id: UUID(),
            petStayID: selectedStayID,
            type: .feeding,
            scheduledTime: Date(),
            instructions: "Feed the pet.",
            isCompleted: false
        )

        let otherTask = CareTask(
            id: UUID(),
            petStayID: otherStayID,
            type: .walking,
            scheduledTime: Date(),
            instructions: "Walk the pet.",
            isCompleted: false
        )

        let useCase = ReviewDailyCarePlanUseCase()

        let result = useCase.execute(
            petStayID: selectedStayID,
            tasks: [selectedTask, otherTask]
        )

        #expect(result.count == 1)
        #expect(result[0].id == selectedTask.id)
    }

    @Test
    func sortsTasksByScheduledTime() {
        let stayID = UUID()
        let baseTime = Date()

        let laterTask = CareTask(
            id: UUID(),
            petStayID: stayID,
            type: .walking,
            scheduledTime: baseTime.addingTimeInterval(2 * 60 * 60),
            instructions: "Walk the pet.",
            isCompleted: false
        )

        let earlierTask = CareTask(
            id: UUID(),
            petStayID: stayID,
            type: .feeding,
            scheduledTime: baseTime,
            instructions: "Feed the pet.",
            isCompleted: false
        )

        let useCase = ReviewDailyCarePlanUseCase()

        let result = useCase.execute(
            petStayID: stayID,
            tasks: [laterTask, earlierTask]
        )

        #expect(result.count == 2)
        #expect(result[0].id == earlierTask.id)
        #expect(result[1].id == laterTask.id)
    }

    @Test
    func returnsEmptyListWhenNoTasksMatchPetStay() {
        let selectedStayID = UUID()
        let otherStayID = UUID()

        let task = CareTask(
            id: UUID(),
            petStayID: otherStayID,
            type: .feeding,
            scheduledTime: Date(),
            instructions: "Feed the pet.",
            isCompleted: false
        )

        let useCase = ReviewDailyCarePlanUseCase()

        let result = useCase.execute(
            petStayID: selectedStayID,
            tasks: [task]
        )

        #expect(result.isEmpty)
    }
}
