//
//  AppearanceStyle.swift
//  OCKSample
//
//  Created by  on 3/2/23.
//  Copyright © 2023 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKitUI

struct AppearanceStyle: OCKAppearanceStyler {
    var shadowOpacity1: Float { 1.0 }
    var shadowRadius1: CGFloat { 12 }
    var shadowOffset1: CGSize { CGSize(width: 3, height: 4) }
    var opacity1: CGFloat { 0.45 }
    var lineWidth1: CGFloat { 1 }

    var cornerRadius1: CGFloat { 12 }
    var cornerRadius2: CGFloat { 12 }

    var borderWidth1: CGFloat { 2 }
    var borderWidth2: CGFloat { 2 }
}
