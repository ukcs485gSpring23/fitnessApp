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

struct Weight: Surveyable {
    static var surveyType: Survey {
        Survey.weight
    }

    static var formIdentifier: String {
        "\(Self.identifier()).form"
    }

    static var currentWeightItemIdentifier: String {
        "\(Self.identifier()).form.currentWeight"
    }

    static var goalWeightItemIdentifier: String {
        "\(Self.identifier()).form.goalWeight"
    }

    static var goalTimeItemIdentifier: String {
        "\(Self.identifier()).form.goalTime"
    }
}

#if canImport(ResearchKit)
extension Weight {
    func createSurvey() -> ORKTask {

        let weightFormat = ORKAnswerFormat.weightAnswerFormat(with: .USC, numericPrecision: .default)

        let currentWeightItem = ORKFormItem(identifier: Self.currentWeightItemIdentifier,
                                            text: "What is your current weight in lbs?",
                                            answerFormat: weightFormat)
        currentWeightItem.isOptional = false

        let goalWeightItem = ORKFormItem(identifier: Self.goalWeightItemIdentifier,
                                            text: "What is your goal weight in lbs?",
                                            answerFormat: weightFormat)
        goalWeightItem.isOptional = false

        let goalTimeFormat = ORKAnswerFormat.integerAnswerFormat(withUnit: "weeks")

        let goalTimeItem = ORKFormItem(identifier: Self.goalTimeItemIdentifier,
                                            text: "How long until you reach your goal?",
                                            answerFormat: goalTimeFormat)
        goalTimeItem.isOptional = false

        let formStep = ORKFormStep(
            identifier: Self.formIdentifier,
            title: "Weight Goal",
            text: "Please answer the following questions."
        )
        formStep.formItems = [currentWeightItem, goalWeightItem, goalTimeItem]
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

            let numericResults = response
                .results?.compactMap({ $0 as? ORKNumericQuestionResult }),

            let currentWeightAnswer = numericResults
                .first(where: { $0.identifier == Self.currentWeightItemIdentifier })?
                .numericAnswer,

            let goalWeightAnswer = numericResults
                .first(where: { $0.identifier == Self.goalWeightItemIdentifier })?
                .numericAnswer,

            let goalTimeAnswer = numericResults
                .first(where: { $0.identifier == Self.goalTimeItemIdentifier })?
                .numericAnswer
        else {
            assertionFailure("Failed to extract answers from check in survey!")
            return nil
        }

        var currentWeightValue = OCKOutcomeValue(Double(truncating: currentWeightAnswer))
        currentWeightValue.kind = Self.currentWeightItemIdentifier

        var goalWeightValue = OCKOutcomeValue(Double(truncating: goalWeightAnswer))
        goalWeightValue.kind = Self.goalWeightItemIdentifier

        var goalTimeValue = OCKOutcomeValue(Double(truncating: goalTimeAnswer))
        goalTimeValue.kind = Self.goalTimeItemIdentifier

        return [currentWeightValue, goalWeightValue, goalTimeValue]
    }
}
#endif
