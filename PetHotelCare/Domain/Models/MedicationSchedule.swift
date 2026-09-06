//
//  MedicationSchedule.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/6.
//
import Foundation

/// Represents a medication schedule for a pet during its hotel stay.
///
/// The schedule records the medication name, dosage, scheduled administration
/// time, and the minimum safe interval between two administrations.
///
/// Medication must not be administered again before the minimum interval
/// has elapsed since the previous administration.
struct MedicationSchedule: Identifiable {
    let id: UUID
    let petStayID: UUID
    let medicationName: String
    let dosage: String
    let scheduledTime: Date
    let minimumIntervalHours: Double
}
