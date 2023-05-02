//
//  CustomCardViewModel.swift
//  OCKSample
//
//  Created by Corey Baker on 4/25/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import CareKit
import CareKitStore
import Foundation

class CustomCardViewModel: CardViewModel {
    /*
     TODOq: Place any additional properties needed for your custom Card.
     Be sure to @Published them if they update your view
     */

    @Published var currentButton: ButtonOption = .isZero
    @Published var value2: OCKOutcomeValue?

    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()

    /// This value can be used directly in Text() views.

    var goalCaloriesAsInt: Int {
        get {
            guard let intValue = value2?.integerValue else {
                return 0
            }
            return intValue
        }
        // swiftl int:disable:next unused_setter_value
       set {
            value2 = OCKOutcomeValue(newValue)
        }
    }

    var userCaloriesAsInt: Int {
        get {
            guard let intValue = value?.integerValue else {
                return 0
            }
            return intValue
        }
        // swiftl int:disable:next unused_setter_value
       set {
            value = OCKOutcomeValue(newValue)
        }
    }

    func compareCalories() async {
        if goalCaloriesAsInt == 0 && userCaloriesAsInt == 0 {
            currentButton = .isZero
            return
        }
        let difference = abs(goalCaloriesAsInt - userCaloriesAsInt)
        if difference <= 50 {
            currentButton = .goalMet
        } else {
            currentButton = .goalFailed
        }
    }
}
