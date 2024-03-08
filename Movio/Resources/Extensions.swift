//
//  Extensions.swift
//  Movio
//
//  Created by iMac on 04/03/2024.
//

import UIKit

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0.0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}
