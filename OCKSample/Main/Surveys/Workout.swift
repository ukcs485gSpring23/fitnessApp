//
//  CheckIn.swift
//  OCKSample
//
//  Created by Corey Baker on 4/14/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import CareKitStore
#if canImport(ResearchKit)
import ResearchKit
#endif

struct Workout: Surveyable {
    static var surveyType: Survey {
        Survey.workout
    }

    static var formIdentifier: String {
        "\(Self.identifier()).form"
    }

    static var workoutItemIdentifier: String {
        "\(Self.identifier()).form.workoutMinutes"
    }

    static var goalItemIdentifier: String {
        "\(Self.identifier()).form.goalMinutes"
    }
}

#if canImport(ResearchKit)
extension Workout {
    func createSurvey() -> ORKTask {

        let workoutAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 180,
            minimumValue: 0,
            defaultValue: 0,
            step: 15,
            vertical: false,
            maximumValueDescription: "3 Hours",
            minimumValueDescription: "0"
        )

        let workoutItem = ORKFormItem(
            identifier: Self.workoutItemIdentifier,
            text: "How many minutes did you workout today?",
            answerFormat: workoutAnswerFormat
        )
        workoutItem.isOptional = false

        let goalAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 180,
            minimumValue: 0,
            defaultValue: 0,
            step: 15,
            vertical: false,
            maximumValueDescription: "3 Hours",
            minimumValueDescription: "0"
        )

        let goalItem = ORKFormItem(
            identifier: Self.goalItemIdentifier,
            text: "What was your goal today?",
            answerFormat: goalAnswerFormat
        )
        goalItem.isOptional = false

        let formStep = ORKFormStep(
            identifier: Self.formIdentifier,
            title: "Check In",
            text: "Please answer the following questions."
        )
        formStep.formItems = [workoutItem, goalItem]
        formStep.isOptional = false

        let surveyTask = ORKOrderedTask(
            identifier: identifier(),
            steps: [formStep]
        )
        return surveyTask
    }

    func extractAnswers(_ result: ORKTaskResult) -> [OCKOutcomeValue]? {

        guard
            let response = result.results?
                .compactMap({ $0 as? ORKStepResult })
                .first(where: { $0.identifier == Self.formIdentifier }),

            let scaleResults = response
                .results?.compactMap({ $0 as? ORKScaleQuestionResult }),

            let workoutAnswer = scaleResults
                .first(where: { $0.identifier == Self.workoutItemIdentifier })?
                .scaleAnswer,

            let goalAnswer = scaleResults
                .first(where: { $0.identifier == Self.goalItemIdentifier })?
                .scaleAnswer
        else {
            assertionFailure("Failed to extract answers from check in survey!")
            return nil
        }

        var workoutValue = OCKOutcomeValue(Double(truncating: workoutAnswer))
        workoutValue.kind = Self.workoutItemIdentifier

        var goalValue = OCKOutcomeValue(Double(truncating: goalAnswer))
        goalValue.kind = Self.goalItemIdentifier

        return [workoutValue, goalValue]
    }
}
#endif
