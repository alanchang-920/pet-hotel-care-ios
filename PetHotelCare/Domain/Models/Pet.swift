//
//  Pet.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/6.
//

import Foundation

/// Represents a pet that receives care while staying at the pet hotel.
///
/// A pet contains the core information care staff need to identify
/// the animal and provide appropriate care during its stay.
struct Pet: Identifiable {
    let id: UUID
    let name: String
    let species: PetSpecies
    let breed: String
    let dateOfBirth: Date
}

/// Represents the species of a guest pet accepted by the hotel.
enum PetSpecies: String {
    case dog = "Dog"
    case cat = "Cat"
}
