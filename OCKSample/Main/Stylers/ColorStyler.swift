//
//  ColorStyler.swift
//  OCKSample
//
//  Created by Corey Baker on 10/16/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitUI
import UIKit

struct ColorStyler: OCKColorStyler {
    #if os(iOS)
    var label: UIColor {
        FontColorKey.defaultValue
    }
    var tertiaryLabel: UIColor {
        TintColorKey.defaultValue
    }
    var secondaryLabel: UIColor {
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    var separator: UIColor {
        TintColorKey.defaultValue
    }

    var secondaryCustomGroupedBackground: UIColor {
        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    #endif
}
