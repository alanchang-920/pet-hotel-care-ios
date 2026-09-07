//
//  ReviewDailyCarePlanUseCase.swift
//  PetHotelCare
//
//  Created by Chang Chia ming on 2026/9/8.
//
import Foundation

/// Returns the scheduled care tasks for a specific pet stay.
///
/// Only tasks belonging to the selected pet stay are returned,
/// and the tasks are ordered by their scheduled time.
struct ReviewDailyCarePlanUseCase {

    func execute(
        petStayID: UUID,
        tasks: [CareTask]
    ) -> [CareTask] {

        tasks
            .filter { $0.petStayID == petStayID }
            .sorted { $0.scheduledTime < $1.scheduledTime }
    }
}
