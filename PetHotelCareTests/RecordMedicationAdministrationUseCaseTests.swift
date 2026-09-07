//
//  RecordMedicationAdministrationUseCaseTests.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//
import Foundation
import Testing
@testable import PetHotelCare

struct RecordMedicationAdministrationUseCaseTests {

    private func makeSchedule(
        minimumIntervalHours: Double = 8
    ) -> MedicationSchedule {
        MedicationSchedule(
            id: UUID(),
            petStayID: UUID(),
            medicationName: "Antibiotic",
            dosage: "1 tablet",
            scheduledTime: Date(),
            minimumIntervalHours: minimumIntervalHours
        )
    }

    private func makeStaff() -> StaffMember {
        StaffMember(
            id: UUID(),
            name: "Emma"
        )
    }

    @Test
    func recordsFirstMedicationAdministrationSuccessfully() throws {
        let schedule = makeSchedule()
        let staff = makeStaff()
        let administeredAt = Date()

        let useCase = RecordMedicationAdministrationUseCase()

        let record = try useCase.execute(
            schedule: schedule,
            previousAdministration: nil,
            staff: staff,
            administeredAt: administeredAt
        )

        #expect(record.petStayID == schedule.petStayID)
        #expect(record.taskType == .medication)
        #expect(record.completedAt == administeredAt)
        #expect(record.completedBy.id == staff.id)
    }

    @Test
    func rejectsMedicationBeforeMinimumInterval() {
        let schedule = makeSchedule(minimumIntervalHours: 8)
        let staff = makeStaff()

        let previousTime = Date()
        let previousRecord = CareActivityRecord(
            id: UUID(),
            petStayID: schedule.petStayID,
            careTaskID: schedule.id,
            taskType: .medication,
            completedAt: previousTime,
            completedBy: staff,
            notes: nil
        )

        let tooEarlyTime = previousTime.addingTimeInterval(7 * 60 * 60)

        let useCase = RecordMedicationAdministrationUseCase()

        #expect(throws: PetHotelError.medicationTooSoon) {
            try useCase.execute(
                schedule: schedule,
                previousAdministration: previousRecord,
                staff: staff,
                administeredAt: tooEarlyTime
            )
        }
    }

    @Test
    func allowsMedicationAtExactMinimumInterval() throws {
        let schedule = makeSchedule(minimumIntervalHours: 8)
        let staff = makeStaff()

        let previousTime = Date()
        let previousRecord = CareActivityRecord(
            id: UUID(),
            petStayID: schedule.petStayID,
            careTaskID: schedule.id,
            taskType: .medication,
            completedAt: previousTime,
            completedBy: staff,
            notes: nil
        )

        let exactBoundaryTime =
            previousTime.addingTimeInterval(8 * 60 * 60)

        let useCase = RecordMedicationAdministrationUseCase()

        let record = try useCase.execute(
            schedule: schedule,
            previousAdministration: previousRecord,
            staff: staff,
            administeredAt: exactBoundaryTime
        )

        #expect(record.completedAt == exactBoundaryTime)
        #expect(record.taskType == .medication)
    }
}
