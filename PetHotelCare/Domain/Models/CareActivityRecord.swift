//
//  CareActivityRecord.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/6.
//
import Foundation

/// Represents a completed care activity performed for a guest pet.
///
/// A record provides an audit trail showing which care task was completed,
/// when it was completed, and which authorised staff member performed it.
///
/// Completed care records are retained so other staff can verify that
/// required care has already been provided.
struct CareActivityRecord: Identifiable {
    let id: UUID
    let petStayID: UUID
    let careTaskID: UUID
    let taskType: CareTaskType
    let completedAt: Date
    let completedBy: StaffMember
    let notes: String?
}
