//
//  OCKHealthKitPassthroughStore.swift
//  OCKSample
//
//  Created by Corey Baker on 1/5/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
import HealthKit
import os.log

extension OCKHealthKitPassthroughStore {

    func addTasksIfNotPresent(_ tasks: [OCKHealthKitTask]) async throws {
        let tasksToAdd = tasks
        let taskIdsToAdd = tasksToAdd.compactMap { $0.id }

        // Prepare query to see if tasks are already added
        var query = OCKTaskQuery(for: Date())
        query.ids = taskIdsToAdd

        let foundTasks = try await fetchTasks(query: query)
        var tasksNotInStore = [OCKHealthKitTask]()

        // Check results to see if there's a missing task
        tasksToAdd.forEach { potentialTask in
            if foundTasks.first(where: { $0.id == potentialTask.id }) == nil {
                tasksNotInStore.append(potentialTask)
            }
        }

        // Only add if there's a new task
        if tasksNotInStore.count > 0 {
            do {
                _ = try await addTasks(tasksNotInStore)
                Logger.ockHealthKitPassthroughStore.info("Added tasks into HealthKitPassthroughStore!")
            } catch {
                Logger.ockHealthKitPassthroughStore.error("Error adding HealthKitTasks: \(error)")
            }
        }
    }

    func populateCarePlans(patientUUID: UUID? = nil) async throws -> OCKCarePlan {
            let healthCarePlan = OCKCarePlan(id: CarePlanID.health.rawValue,
                                              title: "Health Care Plan",
                                              patientUUID: patientUUID)
            try await AppDelegateKey
                .defaultValue?
                .storeManager
                .addCarePlansIfNotPresent([healthCarePlan],
                                          patientUUID: patientUUID)

        return healthCarePlan
        }

    /*
        TODOy: You need to tie an OCKPatient.
       */
       func populateSampleData(_ patientUUID: UUID? = nil) async throws {

        let carePlan = try await populateCarePlans(patientUUID: patientUUID)
        let schedule = OCKSchedule.dailyAtTime(
            hour: 8, minutes: 0, start: Date(), end: nil, text: nil,
            duration: .hours(12), targetValues: [OCKOutcomeValue(2000.0, units: "Steps")])
           /*
                   TODOy: You need to tie an OCKCarePlan to each HealthKit task. There was a
                   a method added recently in Extensions/OCKStore.swift to assist with this. Use this method here
                   and write a comment and state if it's an "instance method" or "type method". If you
                   are trying to copy the method to this file, you are using the code incorrectly. Be
                   sure to understand the difference between a type method and instance method.
                   */

           try await OCKStore.getCarePlanUUIDs() // This is a type method
        var steps = OCKHealthKitTask(
            id: TaskID.steps,
            title: "Steps",
            carePlanUUID: carePlan.uuid,
            schedule: schedule,
            healthKitLinkage: OCKHealthKitLinkage(
                quantityIdentifier: .stepCount,
                quantityType: .cumulative,
                unit: .count()))
        steps.asset = "figure.walk"
        try await addTasksIfNotPresent([steps])
    }
}
