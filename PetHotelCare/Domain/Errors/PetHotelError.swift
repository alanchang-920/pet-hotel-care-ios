//
//  PetHotelError.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//
import Foundation

/// Represents business-rule errors that can occur while staff
/// perform care activities for guest pets.
enum PetHotelError: Error, Equatable {

    /// The selected care task has already been completed.
    case taskAlreadyCompleted

    /// Medication cannot be administered because the required
    /// minimum interval has not yet elapsed.
    case medicationTooSoon
}
