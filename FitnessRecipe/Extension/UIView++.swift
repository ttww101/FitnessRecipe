//
//  UIView++.swift
//  FitnessRecipe
//
//  Created by Apple on 5/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBackground(_ image: UIImageView, _ imageMode: UIView.ContentMode) {
        // you can change the content mode:
        image.contentMode = imageMode
        
        self.addSubview(image)
        self.addViewLayout(image, 0, 0, 0, 0)
    }
    
    func addViewLayout(_ addView: UIView,_ top: CGFloat, _ bottom: CGFloat, _ trailing: CGFloat, _ leading: CGFloat) {
        let metrics = ["t": top, "b": bottom, "r": trailing, "l": leading]
        let viewsDict = ["subview": addView]
        addView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(t)-[subview]-(b)-|", options: [], metrics: metrics, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(l)-[subview]-(r)-|", options: [], metrics: metrics, views: viewsDict))
    }
    
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func addGradual() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor(red: 76/255, green: 104/255, blue: 234/255, alpha: 1).cgColor,
            UIColor(red: 129/255, green: 200/255, blue: 245/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.addSublayer(gradientLayer)

    }
}
