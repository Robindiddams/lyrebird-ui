//
//  PrettyButton.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/8/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit

class PrettyButton: UIButton {
    
    var gradient: CAGradientLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        self.layer.cornerRadius = rounded ? 5 : 0
        self.clipsToBounds = true
    }
    
    func setGradient(top: UIColor, bottom: UIColor) {
        let colorTop = top.cgColor
        let colorBottom = bottom.cgColor
        self.setGradient(colors: [colorTop, colorBottom])
    }
    
    func setGradient(colors: [CGColor]) {
        self.gradient?.removeFromSuperlayer()
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.frame = self.bounds
        self.gradient = gradient
        self.layer.addSublayer(gradient)
    }
}
