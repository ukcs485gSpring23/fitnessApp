//
//  Survey.swift
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

enum Survey: String, CaseIterable, Identifiable {
    var id: Self { self }
    case onboard = "Onboard"
    case checkIn = "Check In"
    case rangeOfMotion = "Range of Motion"
    case workout = "Workout"
    case weight = "Weight"

    func type() -> Surveyable {
        switch self {
        case .onboard:
            return Onboard()
        case .checkIn:
            return CheckIn()
        case .rangeOfMotion:
            return RangeOfMotion()
        case .workout:
            return Workout()
        case .weight:
            return Weight()
        }
    }
}
