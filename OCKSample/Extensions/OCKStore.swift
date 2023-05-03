//
//  OCKStore.swift
//  OCKSample
//
//  Created by Corey Baker on 1/5/22.
//  Copyright © 2022 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
import Contacts
import os.log
import ParseSwift
import ParseCareKit

extension OCKStore {

    func addTasksIfNotPresent(_ tasks: [OCKTask]) async throws {
        let taskIdsToAdd = tasks.compactMap { $0.id }

        // Prepare query to see if tasks are already added
        var query = OCKTaskQuery(for: Date())
        query.ids = taskIdsToAdd

        let foundTasks = try await fetchTasks(query: query)
        var tasksNotInStore = [OCKTask]()

        // Check results to see if there's a missing task
        tasks.forEach { potentialTask in
            if foundTasks.first(where: { $0.id == potentialTask.id }) == nil {
                tasksNotInStore.append(potentialTask)
            }
        }

        // Only add if there's a new task
        if tasksNotInStore.count > 0 {
            do {
                _ = try await addTasks(tasksNotInStore)
                Logger.ockStore.info("Added tasks into OCKStore!")
            } catch {
                Logger.ockStore.error("Error adding tasks: \(error)")
            }
        }
    }

    func populateCarePlans(patientUUID: UUID? = nil) async throws {
            let checkInCarePlan = OCKCarePlan(id: CarePlanID.input.rawValue,
                                              title: "Check in Care Plan",
                                              patientUUID: patientUUID)
            try await AppDelegateKey
                .defaultValue?
                .storeManager
                .addCarePlansIfNotPresent([checkInCarePlan],
                                          patientUUID: patientUUID)
        }

    @MainActor
        class func getCarePlanUUIDs() async throws -> [CarePlanID: UUID] {
            var results = [CarePlanID: UUID]()

            guard let store = AppDelegateKey.defaultValue?.store else {
                return results
            }

            var query = OCKCarePlanQuery(for: Date())
            query.ids = [CarePlanID.stat.rawValue,
                         CarePlanID.input.rawValue]

            let foundCarePlans = try await store.fetchCarePlans(query: query)
            // Populate the dictionary for all CarePlan's
            CarePlanID.allCases.forEach { carePlanID in
                results[carePlanID] = foundCarePlans
                    .first(where: { $0.id == carePlanID.rawValue })?.uuid
            }
            return results
        }

    func addContactsIfNotPresent(_ contacts: [OCKContact]) async throws {
        let contactIdsToAdd = contacts.compactMap { $0.id }

        // Prepare query to see if contacts are already added
        var query = OCKContactQuery(for: Date())
        query.ids = contactIdsToAdd

        let foundContacts = try await fetchContacts(query: query)
        var contactsNotInStore = [OCKContact]()

        // Check results to see if there's a missing task
        contacts.forEach { potential in
            if foundContacts.first(where: { $0.id == potential.id }) == nil {
                contactsNotInStore.append(potential)
            }
        }

        // Only add if there's a new task
        if contactsNotInStore.count > 0 {
            do {
                _ = try await addContacts(contactsNotInStore)
                Logger.ockStore.info("Added contacts into OCKStore!")
            } catch {
                Logger.ockStore.error("Error adding contacts: \(error)")
            }
        }
    }

    // Adds tasks and contacts into the store
    func populateSampleData(_ patientUUID: UUID? = nil) async throws {
        try await populateCarePlans(patientUUID: patientUUID)

        let carePlanUUIDs = try await Self.getCarePlanUUIDs()

        var element = OCKScheduleElement(start: Date(),
                                         end: nil,
                                         interval: DateComponents(day: 2),
                                         text: nil,
                                         targetValues: [OCKOutcomeValue(1000, units: "goals")],
                                         duration: .allDay)
        let everyOtherDay = OCKSchedule(composing: [element])

        element = OCKScheduleElement(start: Date(),
                                         end: nil,
                                         interval: DateComponents(day: 7),
                                         text: nil,
                                         targetValues: [OCKOutcomeValue(1000, units: "goals")],
                                         duration: .allDay)
        let weekly = OCKSchedule(composing: [element])

        let daily = OCKSchedule.dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: nil)

        var logWorkout = OCKTask(id: TaskID.logWorkout,
                                 title: "Log Your Meals",
                                 carePlanUUID: carePlanUUIDs[.input],
                                 schedule: everyOtherDay)
        logWorkout.instructions = "Press each time you eat a meal."
        logWorkout.impactsAdherence = false
        logWorkout.asset = "plus.circle.fill"
        logWorkout.card = .button

        var run = OCKTask(id: TaskID.run,
                             title: "Run Today",
                             carePlanUUID: carePlanUUIDs[.input],
                             schedule: weekly)

        run.impactsAdherence = true
        run.instructions = "Go for a run today."
        run.asset = "figure.run"
        run.card = .instruction

        var calorie = OCKTask(id: TaskID.calorie,
                                        title: "Calories Consumed",
                                        carePlanUUID: carePlanUUIDs[.input],
                                        schedule: daily)

        calorie.impactsAdherence = false
        calorie.instructions = "Compare your calories consumed with your goal."
        calorie.asset = "repeat.circle"
        calorie.card = .custom

        var qotd = OCKTask(id: TaskID.qotd,
                                        title: "Quote of the Day!",
                                        carePlanUUID: carePlanUUIDs[.input],
                                        schedule: daily)
               qotd.impactsAdherence = false
               qotd.instructions = "Put your motivational QOTD here!"
               qotd.asset = "mic.fill"
               qotd.card = .custom2

        var link = OCKTask(id: TaskID.calorieCalculator,
                           title: "Calorie Calculator",
                           carePlanUUID: carePlanUUIDs[.input],
                           schedule: daily)

        link.impactsAdherence = false
        link.card = .link
        link.instructions = "Click link."

        var strengthTraining = OCKTask(id: TaskID.strengthTraining,
                                       title: "Strength Training",
                                       carePlanUUID: carePlanUUIDs[.input],
                                       schedule: everyOtherDay)

        strengthTraining.card = .simple
        strengthTraining.impactsAdherence = true
        strengthTraining.instructions = "To Do: Strength Training"
        strengthTraining.asset = "dumbbell"

        try await addTasksIfNotPresent([calorie, qotd, run, logWorkout, link, strengthTraining])

        try await addOnboardingTask(carePlanUUIDs[.stat])
        try await addSurveyTasks(carePlanUUIDs[.input])

        var contact1 = OCKContact(id: "jane",
                                  givenName: "Jane",
                                  familyName: "Daniels",
                                  carePlanUUID: carePlanUUIDs[.input])
        contact1.asset = "JaneDaniels"
        contact1.title = "Family Practice Doctor"
        contact1.role = "Dr. Daniels is a family practice doctor with 8 years of experience."
        contact1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "janedaniels@uky.edu")]
        contact1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(859) 257-2000")]
        contact1.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(859) 357-2040")]

        contact1.address = {
            let address = OCKPostalAddress()
            address.street = "2195 Harrodsburg Rd"
            address.city = "Lexington"
            address.state = "KY"
            address.postalCode = "40504"
            return address
        }()

        var contact2 = OCKContact(id: "matthew", givenName: "Matthew",
                                  familyName: "Reiff", carePlanUUID: carePlanUUIDs[.input])
        contact2.asset = "MatthewReiff"
        contact2.title = "OBGYN"
        contact2.role = "Dr. Reiff is an OBGYN with 13 years of experience."
        contact2.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(859) 257-1000")]
        contact2.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(859) 257-1234")]
        contact2.address = {
            let address = OCKPostalAddress()
            address.street = "1000 S Limestone"
            address.city = "Lexington"
            address.state = "KY"
            address.postalCode = "40536"
            return address
        }()

        try await addContactsIfNotPresent([contact1, contact2])
    }

    func addOnboardingTask(_ carePlanUUID: UUID? = nil) async throws {
            let onboardSchedule = OCKSchedule.dailyAtTime(
                        hour: 0, minutes: 0,
                        start: Date(), end: nil,
                        text: "Task Due!",
                        duration: .allDay
                    )

            var onboardTask = OCKTask(
                id: Onboard.identifier(),
                title: "Onboard",
                carePlanUUID: carePlanUUID,
                schedule: onboardSchedule
            )
            onboardTask.instructions = "You'll need to agree to some terms and conditions before we get started!"
            onboardTask.impactsAdherence = false
            onboardTask.card = .survey
            onboardTask.survey = .onboard

            try await addTasksIfNotPresent([onboardTask])
        }

        func addSurveyTasks(_ carePlanUUID: UUID? = nil) async throws {
            let workoutSchedule = OCKSchedule.dailyAtTime(
                hour: 8, minutes: 0,
                start: Date(), end: nil,
                text: nil
            )

            let thisMorning = Calendar.current.startOfDay(for: Date())

            let nextWeek = Calendar.current.date(
                byAdding: .weekOfYear,
                value: 1,
                to: Date()
            )!

            let nextMonth = Calendar.current.date(
                byAdding: .month,
                value: 1,
                to: thisMorning
            )

            let dailyElement = OCKScheduleElement(
                start: thisMorning,
                end: nextWeek,
                interval: DateComponents(day: 1),
                text: nil,
                targetValues: [],
                duration: .allDay
            )

            let weeklyElement = OCKScheduleElement(
                start: nextWeek,
                end: nextMonth,
                interval: DateComponents(weekOfYear: 1),
                text: nil,
                targetValues: [],
                duration: .allDay
            )

            let weightSchedule = OCKSchedule(
                composing: [dailyElement, weeklyElement]
            )

            var workoutTask = OCKTask(
                id: Workout.identifier(),
                title: "Workout Minutes",
                carePlanUUID: carePlanUUID,
                schedule: workoutSchedule
            )
            workoutTask.card = .survey
            workoutTask.survey = .workout

            var weightTask = OCKTask(
                id: Weight.identifier(),
                title: "Weight Goals",
                carePlanUUID: carePlanUUID,
                schedule: weightSchedule
            )
            weightTask.card = .survey
            weightTask.survey = .weight
            try await addTasksIfNotPresent([workoutTask, weightTask])
        }
}
