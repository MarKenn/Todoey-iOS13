//
//  UIColor+Lightness.swift
//  Todoey
//
//  Created by Mark Kenneth Bayona on 9/3/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

extension UIColor {
    func isLight() -> Bool {
        guard let components = cgColor.components, components.count > 2 else {return false}
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
}
