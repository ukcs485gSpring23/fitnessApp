//
//  SurveyViewSynchronizer.swift
//  OCKSample
//
//  Created by Corey Baker on 4/14/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKit
import CareKitStore
import CareKitUI
import ResearchKit
import UIKit
import os.log

final class SurveyViewSynchronizer: OCKSurveyTaskViewSynchronizer {

    override func updateView(_ view: OCKInstructionsTaskView,
                             context: OCKSynchronizationContext<OCKTaskEvents>) {

        super.updateView(view, context: context)

        if let event = context.viewModel.first?.first, event.outcome != nil {
            view.instructionsLabel.isHidden = false
            /*
             TODOy: You need to modify this so the instuction label shows
             correctly for each Task/Card.
             Hint - Each event (OCKAnyEvent) has a task. How can you use
             this task to determine what instruction answers should show?
             Look at how the CareViewController differentiates between
             surveys.
             */

            if let task = event.task as? OCKTask {
                if task.survey == .checkIn {
                    let pain = event.answer(kind: CheckIn.painItemIdentifier)
                    let sleep = event.answer(kind: CheckIn.sleepItemIdentifier)
                    view.instructionsLabel.text = """
                        Pain: \(Int(pain))
                        Sleep: \(Int(sleep)) hours
                        """
                }
                if task.survey == .workout {
                    let workoutMinutes = event.answer(kind: Workout.workoutItemIdentifier)
                    let goalMinutes = event.answer(kind: Workout.goalItemIdentifier)
                    view.instructionsLabel.text = """
                        Workout Minutes: \(Int(workoutMinutes))
                        Goal Minutes: \(Int(goalMinutes))
                        """
                }

                if task.survey == .weight {
                    let currentWeight = event.answer(kind: Weight.currentWeightItemIdentifier) * 2.20462
                    let goalWeight = event.answer(kind: Weight.goalWeightItemIdentifier) * 2.20462
                    let goalTime = event.answer(kind: Weight.goalTimeItemIdentifier)
                    let weightDifference = abs(goalWeight-currentWeight)
                    let perWeek: Double = weightDifference / goalTime
                    let perWeekString = String(format: "%.2f", perWeek)

                    view.instructionsLabel.text = """
                        Current Weight: \(Int(currentWeight)) lbs
                        Goal Weight: \(Int(goalWeight)) lbs
                        Goal Time: \(Int(goalTime)) weeks
                        This will take about \(perWeekString) lbs/week.
                        """

                }
            }

        } else {
            view.instructionsLabel.isHidden = true
        }
    }
}
