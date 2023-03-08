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
        #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }

    #endif
}
