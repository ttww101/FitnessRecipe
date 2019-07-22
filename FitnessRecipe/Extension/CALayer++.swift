//
//  CALayer++.swift
//  FitnessRecipe
//
//  Created by Apple on 5/31/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension CALayer {
    func addShadow() {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.2
        self.shadowRadius = 10
        self.shadowColor = UIColor.black.cgColor
        self.masksToBounds = false
    }
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
    }
}
