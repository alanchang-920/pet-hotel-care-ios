//
//  MockPetHotelData.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/6.
//
import Foundation

/// Provides sample pet hotel data for development, previews, and testing.
///
/// This mock data represents the current state of the pet hotel without
/// requiring a persistent database or external service.
enum MockPetHotelData {

    // MARK: - Staff

    static let currentStaff = StaffMember(
        id: UUID(),
        name: "Emma"
    )

    // MARK: - Pets

    static let milo = Pet(
        id: UUID(),
        name: "Milo",
        species: .dog,
        breed: "Golden Retriever",
        dateOfBirth: makeDate(year: 2021, month: 3, day: 15)
    )

    static let luna = Pet(
        id: UUID(),
        name: "Luna",
        species: .cat,
        breed: "Domestic Shorthair",
        dateOfBirth: makeDate(year: 2022, month: 7, day: 8)
    )

    // MARK: - Pet Stays

    static let miloStay = PetStay(
        id: UUID(),
        pet: milo,
        roomNumber: "03",
        checkInDate: makeDate(year: 2026, month: 9, day: 6),
        checkOutDate: makeDate(year: 2026, month: 9, day: 10),
        feedingInstructions: "1 cup of dry food at 8 AM and 6 PM.",
        careNotes: "Nervous around loud noises. Enjoys short walks."
    )

    static let lunaStay = PetStay(
        id: UUID(),
        pet: luna,
        roomNumber: "07",
        checkInDate: makeDate(year: 2026, month: 9, day: 5),
        checkOutDate: makeDate(year: 2026, month: 9, day: 9),
        feedingInstructions: "Half a cup of dry food twice daily.",
        careNotes: "Prefers a quiet environment."
    )

    // MARK: - Care Tasks

    static let miloMorningFeeding = CareTask(
        id: UUID(),
        petStayID: miloStay.id,
        type: .feeding,
        scheduledTime: makeDate(
            year: 2026,
            month: 9,
            day: 6,
            hour: 8
        ),
        instructions: "Give 1 cup of dry food.",
        isCompleted: false
    )

    static let miloMorningWalk = CareTask(
        id: UUID(),
        petStayID: miloStay.id,
        type: .walking,
        scheduledTime: makeDate(
            year: 2026,
            month: 9,
            day: 6,
            hour: 10
        ),
        instructions: "Take Milo for a 20-minute walk.",
        isCompleted: true
    )

    static let miloMedicationTask = CareTask(
        id: UUID(),
        petStayID: miloStay.id,
        type: .medication,
        scheduledTime: makeDate(
            year: 2026,
            month: 9,
            day: 6,
            hour: 14
        ),
        instructions: "Administer Carprofen 25 mg.",
        isCompleted: false
    )

    static let lunaMorningFeeding = CareTask(
        id: UUID(),
        petStayID: lunaStay.id,
        type: .feeding,
        scheduledTime: makeDate(
            year: 2026,
            month: 9,
            day: 6,
            hour: 8
        ),
        instructions: "Give half a cup of dry food.",
        isCompleted: false
    )

    static let careTasks = [
        miloMorningFeeding,
        miloMorningWalk,
        miloMedicationTask,
        lunaMorningFeeding
    ]

    // MARK: - Medication

    static let miloMedication = MedicationSchedule(
        id: UUID(),
        petStayID: miloStay.id,
        medicationName: "Carprofen",
        dosage: "25 mg",
        scheduledTime: makeDate(
            year: 2026,
            month: 9,
            day: 6,
            hour: 14
        ),
        minimumIntervalHours: 12
    )

    // MARK: - Care History

    static let miloWalkRecord = CareActivityRecord(
        id: UUID(),
        petStayID: miloStay.id,
        careTaskID: miloMorningWalk.id,
        taskType: .walking,
        completedAt: makeDate(
            year: 2026,
            month: 9,
            day: 6,
            hour: 10,
            minute: 14
        ),
        completedBy: currentStaff,
        notes: "Milo completed his walk without issues."
    )

    static let careHistory = [
        miloWalkRecord
    ]

    // MARK: - Collections

    static let currentStays = [
        miloStay,
        lunaStay
    ]

    // MARK: - Date Helper

    private static func makeDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0
    ) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute

        return Calendar.current.date(from: components)!
    }
}
