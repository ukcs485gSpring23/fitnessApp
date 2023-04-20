//
//  Onboard.swift
//  OCKSample
//
//  Created by  on 4/13/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitStore
#if canImport(ResearchKit)
import ResearchKit
#endif

struct Onboard: Surveyable {
    static var surveyType: Survey {
        Survey.onboard
    }
}

#if canImport(ResearchKit)
extension Onboard {
    /*
     TODOy: Modify the onboarding so it properly represents the
     usecase of your application. Changes should be made to
     each of the steps in this type method. For example, you
     should change: title, detailText, image, and imageContentMode,
     and learnMoreItem.
     */
    func createSurvey() -> ORKTask {
        // The Welcome Instruction step.
        let welcomeInstructionStep = ORKInstructionStep(
            identifier: "\(identifier()).welcome"
        )

        welcomeInstructionStep.title = "Hello!"
        welcomeInstructionStep.detailText = "Welcome to CrFit! Before we can get started, please follow the next steps."
        welcomeInstructionStep.image = UIImage(named: "crLogo.png")
        welcomeInstructionStep.imageContentMode = .center

        // The Informed Consent Instruction step.
        let studyOverviewInstructionStep = ORKInstructionStep(
            identifier: "\(identifier()).overview"
        )

        studyOverviewInstructionStep.title = "Before You Join"
        studyOverviewInstructionStep.iconImage = UIImage(systemName: "checkmark.seal.fill")

        let learnMoreInstructionStep = ORKLearnMoreInstructionStep(
            identifier: "\(identifier()).learnMore"
        )

        learnMoreInstructionStep.text = "You can use your health data to track your personal goals using the app."
        let learnMoreItemHealth = ORKLearnMoreItem()
        learnMoreItemHealth.learnMoreInstructionStep = learnMoreInstructionStep

        let heartBodyItem = ORKBodyItem(
            text: "The app will ask you to share some of your health data.",
            detailText: nil,
            image: UIImage(systemName: "heart.fill"),
            learnMoreItem: learnMoreItemHealth,
            bodyItemStyle: .image
        )

        let completeTasksBodyItem = ORKBodyItem(
            text: "You will be asked to complete various tasks when using this app.",
            detailText: nil,
            image: UIImage(systemName: "checkmark.circle.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )

        let signatureBodyItem = ORKBodyItem(
            text: "Before joining, we will ask you to sign an informed consent document.",
            detailText: nil,
            image: UIImage(systemName: "signature"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )

        let secureDataBodyItem = ORKBodyItem(
            text: "Your data is kept private and secure.",
            detailText: nil,
            image: UIImage(systemName: "lock.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )

        studyOverviewInstructionStep.bodyItems = [
            heartBodyItem,
            completeTasksBodyItem,
            signatureBodyItem,
            secureDataBodyItem
        ]

        // The Signature step (using WebView).
        let webViewStep = ORKWebViewStep(
            identifier: "\(identifier()).signatureCapture",
            html: informedConsentHTML
        )

        webViewStep.showSignatureAfterContent = true

        // The Request Permissions step.
        // TODOy: Set these to HealthKit info you want to display
        // by default.
        let healthKitTypesToWrite: Set<HKSampleType> = [
            .quantityType(forIdentifier: .bodyMassIndex)!,
            .quantityType(forIdentifier: .activeEnergyBurned)!,
            .workoutType(),
            .quantityType(forIdentifier: .stepCount)!
        ]

        let healthKitTypesToRead: Set<HKObjectType> = [
            .characteristicType(forIdentifier: .dateOfBirth)!,
            .workoutType(),
            .quantityType(forIdentifier: .appleStandTime)!,
            .quantityType(forIdentifier: .appleExerciseTime)!
        ]

        let healthKitPermissionType = ORKHealthKitPermissionType(
            sampleTypesToWrite: healthKitTypesToWrite,
            objectTypesToRead: healthKitTypesToRead
        )

        let notificationsPermissionType = ORKNotificationPermissionType(
            authorizationOptions: [.alert, .badge, .sound]
        )

        let motionPermissionType = ORKMotionActivityPermissionType()

        let requestPermissionsStep = ORKRequestPermissionsStep(
            identifier: "\(identifier()).requestPermissionsStep",
            permissionTypes: [
                healthKitPermissionType,
                notificationsPermissionType,
                motionPermissionType
            ]
        )

        requestPermissionsStep.title = "Health Data Request"
        // swiftlint:disable:next line_length
        requestPermissionsStep.text = "Please review the health data types below and enable sharing to contribute to the study."

        // Completion Step
        let completionStep = ORKCompletionStep(
            identifier: "\(identifier()).completionStep"
        )

        completionStep.title = "Enrollment Complete"
        // swiftlint:disable:next line_length
        completionStep.text = "Thank you for enrolling in this study. Your participation will contribute to meaningful research!"

        let surveyTask = ORKOrderedTask(
            identifier: identifier(),
            steps: [
                welcomeInstructionStep,
                studyOverviewInstructionStep,
                webViewStep,
                requestPermissionsStep,
                completionStep
            ]
        )
        return surveyTask
    }

    func extractAnswers(_ result: ORKTaskResult) -> [CareKitStore.OCKOutcomeValue]? {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            Utility.requestHealthKitPermissions()
        }
        return [OCKOutcomeValue(Date())]
    }
}
#endif
