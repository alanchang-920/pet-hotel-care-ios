//
//  StaffMember.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/6.
//
import Foundation

/// Represents an authorised pet hotel staff member who provides
/// and records care for guest pets during a work shift.
///
/// Staff members are identified in care activity records so the hotel
/// can determine who completed each care activity.
struct StaffMember: Identifiable {
    let id: UUID
    let name: String
}
