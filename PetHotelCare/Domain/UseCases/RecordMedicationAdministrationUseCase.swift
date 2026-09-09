//
//  RecordMedicationAdministrationUseCase.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//
import Foundation

/// Handles medication administration for a guest pet.
///
/// Medication may only be administered when the minimum safe interval
/// has elapsed since the previous administration.
struct RecordMedicationAdministrationUseCase {

    func execute(
        schedule: MedicationSchedule,
        careTaskID: UUID,
        previousAdministration: CareActivityRecord?,
        staff: StaffMember,
        administeredAt: Date
    ) throws -> CareActivityRecord {

        if let previousAdministration {
            let elapsedSeconds = administeredAt.timeIntervalSince(
                previousAdministration.completedAt
            )

            let minimumIntervalSeconds =
                schedule.minimumIntervalHours * 60 * 60

            guard elapsedSeconds >= minimumIntervalSeconds else {
                throw PetHotelError.medicationTooSoon
            }
        }

        return CareActivityRecord(
            id: UUID(),
            petStayID: schedule.petStayID,
            careTaskID: careTaskID,
            taskType: .medication,
            completedAt: administeredAt,
            completedBy: staff,
            notes: "\(schedule.medicationName) \(schedule.dosage)"
        )
    }
}
