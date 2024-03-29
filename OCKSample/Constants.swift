//
//  Constants.swift
//  OCKSample
//
//  Created by Corey Baker on 11/27/20.
//  Copyright © 2020 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKit
import CareKitStore
import ParseSwift

/**
 Set to **true** to sync with ParseServer, *false** to sync with iOS/watchOS.
 */
let isSyncingWithCloud = true
/**
 Set to **true** to use WCSession to notify watchOS about updates, **false** to not notify.
 A change in watchOS 9 removes the ability to use Websockets on real Apple Watches,
 preventing auto updates from the Parse Server. See the link for
 details: https://developer.apple.com/forums/thread/715024
 */
let isSendingPushUpdatesToWatch = true

enum AppError: Error {
    case couldntCast
    case couldntBeUnwrapped
    case valueNotFoundInUserInfo
    case remoteClockIDNotAvailable
    case emptyTaskEvents
    case invalidIndexPath(_ indexPath: IndexPath)
    case noOutcomeValueForEvent(_ event: OCKAnyEvent, index: Int)
    case cannotMakeOutcomeFor(_ event: OCKAnyEvent)
    case parseError(_ error: ParseError)
    case error(_ error: Error)
    case errorString(_ string: String)
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .couldntCast:
            return NSLocalizedString("OCKSampleError: Could not cast to required type.",
                                     comment: "Casting error")
        case .couldntBeUnwrapped:
            return NSLocalizedString("OCKSampleError: Could not unwrap a required type.",
                                     comment: "Unwrapping error")
        case .valueNotFoundInUserInfo:
            return NSLocalizedString("OCKSampleError: Could not find the required value in userInfo.",
                                     comment: "Value not found error")
        case .remoteClockIDNotAvailable:
            return NSLocalizedString("OCKSampleError: Could not get remote clock ID.",
                                     comment: "Value not available error")
        case .emptyTaskEvents: return "Task events is empty"
        case let .noOutcomeValueForEvent(event, index): return "Event has no outcome value at index \(index): \(event)"
        case .invalidIndexPath(let indexPath): return "Invalid index path \(indexPath)"
        case .cannotMakeOutcomeFor(let event): return "Cannot make outcome for event: \(event)"
        case .parseError(let error): return "\(error)"
        case .error(let error): return "\(error)"
        case .errorString(let string): return string
        }
    }
}

enum Constants {
    static let parseConfigFileName = "ParseCareKit"
    static let iOSParseCareStoreName = "iOSParseStore"
    static let iOSLocalCareStoreName = "iOSLocalStore"
    static let watchOSParseCareStoreName = "watchOSParseStore"
    static let watchOSLocalCareStoreName = "watchOSLocalStore"
    static let noCareStoreName = "none"
    static let parseUserSessionTokenKey = "requestParseSessionToken"
    static let requestSync = "requestSync"
    static let progressUpdate = "progressUpdate"
    static let finishedAskingForPermission = "finishedAskingForPermission"
    static let shouldRefreshView = "shouldRefreshView"
    static let userLoggedIn = "userLoggedIn"
    static let storeInitialized = "storeInitialized"
    static let userTypeKey = "userType"
    static let card = "card"
    static let survey = "survey"

}

enum MainViewPath {
    case tabs
}

enum CareKitCard: String, CaseIterable, Identifiable {
    var id: Self { self }
    case button = "Button"
    case checklist = "Checklist"
    case featured = "Featured"
    case grid = "Grid"
    case instruction = "Instruction"
    case labeledValue = "Labeled Value"
    case link = "Calorie Calculator"
    case numericProgress = "Active Energy Burned"
    case simple = "Simple"
    case survey = "Survey"
    case custom = "Calories Consumed"
    case custom2 = "QOTD"
}

enum Schedules: String, CaseIterable, Identifiable {
    var id: Self { self }
    case daily = "Daily"
    case weekly = "Weekly"
    case everyOtherDay = "Every Other Day"
}

enum TaskID {
    static let logWorkout = "Log Workout"
    static let run = "run"
    static let stretch = "stretch"
    static let kegels = "kegels"
    static let steps = "steps"
    static let calorieCalculator = "Calorie Calculator"
    static let activeEnergy = "Active Energy"
    static let flightsClimbed = "Flights Climbed"
    static let calorie = "calorie"
    static let qotd = "qotd"
    static let strengthTraining = "Strength Training"

    static var ordered: [String] {
        [Self.qotd, Self.calorieCalculator, Self.calorie,
         Self.activeEnergy, Self.strengthTraining, Self.logWorkout,
         Self.run, Self.flightsClimbed]
    }
}

enum CarePlanID: String, CaseIterable, Identifiable {
    var id: Self { self }
    case stat
    case input
}

enum UserType: String, Codable {
    case patient                           = "Patient"
    case none                              = "None"

    // Return all types as an array, make sure to maintain order above
    func allTypesAsArray() -> [String] {
        return [UserType.patient.rawValue,
                UserType.none.rawValue]
    }
}

enum ButtonOption: CaseIterable {
    case isZero
    case goalMet
    case goalFailed
}

enum InstallationChannel: String {
    case global
}
