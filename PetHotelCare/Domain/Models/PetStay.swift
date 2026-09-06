//
//  PetStay.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/6.
//
import Foundation

/// Represents a pet's current stay at the pet hotel.
///
/// A stay connects a guest pet with its accommodation details and
/// care instructions for a specific check-in period.
///
/// The check-out date must occur after the check-in date.
struct PetStay: Identifiable {
    let id: UUID
    let pet: Pet
    let roomNumber: String
    let checkInDate: Date
    let checkOutDate: Date
    let feedingInstructions: String
    let careNotes: String
}
