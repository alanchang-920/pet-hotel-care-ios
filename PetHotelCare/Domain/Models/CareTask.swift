//
//  CareTask.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/6.
//
import Foundation

/// Represents a scheduled care task that must be completed for a guest pet.
///
/// Each task belongs to a pet stay and describes a required care activity,
/// its scheduled time, and whether the activity has already been completed.
///
/// A care task may only be completed once to prevent duplicate care.
struct CareTask: Identifiable {
    let id: UUID
    let petStayID: UUID
    let type: CareTaskType
    let scheduledTime: Date
    let instructions: String

    var isCompleted: Bool
}

/// Represents the supported types of daily pet care activities.
enum CareTaskType: String {
    case feeding = "Feeding"
    case walking = "Walking"
    case medication = "Medication"
}
