//
//  Extensions.swift
//  Movio
//
//  Created by iMac on 04/03/2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
