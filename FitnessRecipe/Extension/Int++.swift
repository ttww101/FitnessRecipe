//
//  Int++.swift
//  FitnessRecipe
//
//  Created by Apple on 5/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension Int {
    func toTimeString() -> String {
        var value = ""
        if Int(self / 60) < 10 {
            value = "0\(Int(self / 60))"
        } else {
            value = "\(Int(self / 60))"
        }
        value += ":"
        let s = self - (Int(self / 60) * 60)
        if s < 10 {
            value += "0\(s)"
        } else {
            value += "\(s)"
        }
        return value
    }
}
