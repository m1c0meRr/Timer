//
//  Int + Extension.swift
//  Timer
//
//  Created by Sergey Savinkov on 29.06.2023.
//

import UIKit

extension Int {
    
    func convertSeconds() -> (Int, Int) {
        let min = self / 60
        let sec = self % 60
        return (min,sec)
    }
    
    func setZeroForSoceounds() -> String {
        return (Double(self) / 10.0 < 1 ? "0\(self)" : "\(self)")
    }
}
