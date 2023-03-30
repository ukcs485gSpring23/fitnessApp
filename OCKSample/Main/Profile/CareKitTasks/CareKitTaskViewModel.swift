//
//  CareKitTaskViewModel.swift
//  OCKSample
//
//  Created by  on 3/21/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
import os.log

class CareKitTaskViewModel: ObservableObject {
    @Published var title = ""
    @Published var instructions = ""
    @Published var selectedSchedule: Schedules = .daily
    @Published var selectedCard: CareKitCard = .button
    @Published var error: AppError? {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    // MARK: Intents
    func addTask() async {
        guard let appDelegate = AppDelegateKey.defaultValue else {
            error = AppError.couldntBeUnwrapped
            return
        }

        var chosenSchedule: OCKSchedule
        switch selectedSchedule {
        case .daily:
            chosenSchedule = OCKSchedule.dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: nil)
        case .everyOtherDay:
            let element = OCKScheduleElement(start: Date(),
                                             end: nil,
                                             interval: DateComponents(day: 2),
                                             text: nil,
                                             targetValues: [OCKOutcomeValue(1000, units: "goals")],
                                             duration: .allDay)
            chosenSchedule = OCKSchedule(composing: [element])
        case .weekly:
            let element = OCKScheduleElement(start: Date(),
                                             end: nil,
                                             interval: DateComponents(day: 7),
                                             text: nil,
                                             targetValues: [OCKOutcomeValue(1000, units: "goals")],
                                             duration: .allDay)
            chosenSchedule = OCKSchedule(composing: [element])
        default:
            chosenSchedule = OCKSchedule.dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: nil)
        }

        let uniqueId = UUID().uuidString // Create a unique id for each task
        var task = OCKTask(id: uniqueId,
                           title: title,
                           carePlanUUID: nil,
                           schedule: chosenSchedule)
        task.instructions = instructions
        task.card = selectedCard
        do {
            try await appDelegate.storeManager.addTasksIfNotPresent([task])
            Logger.careKitTask.info("Saved task: \(task.id, privacy: .private)")
            // Notify views they should refresh tasks if needed
            NotificationCenter.default.post(.init(name: Notification.Name(rawValue: Constants.shouldRefreshView)))
        } catch {
            self.error = AppError.errorString("Could not add task: \(error.localizedDescription)")
        }
    }

    func addHealthKitTask() async {
        guard let appDelegate = AppDelegateKey.defaultValue else {
            error = AppError.couldntBeUnwrapped
            return
        }
        var chosenSchedule: OCKSchedule
        switch selectedSchedule {
        case .daily:
            chosenSchedule = OCKSchedule.dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: nil)
        case .everyOtherDay:
            let element = OCKScheduleElement(start: Date(),
                                             end: nil,
                                             interval: DateComponents(day: 2),
                                             text: nil,
                                             targetValues: [OCKOutcomeValue(1000, units: "goals")],
                                             duration: .allDay)
            chosenSchedule = OCKSchedule(composing: [element])
        case .weekly:
            let element = OCKScheduleElement(start: Date(),
                                             end: nil,
                                             interval: DateComponents(day: 7),
                                             text: nil,
                                             targetValues: [OCKOutcomeValue(1000, units: "goals")],
                                             duration: .allDay)
            chosenSchedule = OCKSchedule(composing: [element])
        default:
            chosenSchedule = OCKSchedule.dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: nil)
        }
        let uniqueId = UUID().uuidString // Create a unique id for each task
        var healthKitTask = OCKHealthKitTask(id: uniqueId,
                                             title: title,
                                             carePlanUUID: nil,
                                             schedule: chosenSchedule,
                                             healthKitLinkage: .init(quantityIdentifier: .electrodermalActivity,
                                                                     quantityType: .discrete,
                                                                     unit: .count()))
        healthKitTask.instructions = instructions
        healthKitTask.card = selectedCard
        do {
            try await appDelegate.storeManager.addTasksIfNotPresent([healthKitTask])
            Logger.careKitTask.info("Saved HealthKitTask: \(healthKitTask.id, privacy: .private)")
            // Notify views they should refresh tasks if needed
            NotificationCenter.default.post(.init(name: Notification.Name(rawValue: Constants.shouldRefreshView)))
            // Ask HealthKit store for permissions after each new task
            Utility.requestHealthKitPermissions()
        } catch {
            self.error = AppError.errorString("Could not add task: \(error.localizedDescription)")
        }
    }
}
