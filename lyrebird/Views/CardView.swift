//
//  CardView.swift
//  lyrebird
//
//  Created by Robin Diddams on 3/27/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit

class CardView: UIView {
    var progress: Int = 0
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientLayer
    }()
    
    var shape = CAShapeLayer()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.magenta.cgColor, UIColor.cyan.cgColor]
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: frame.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: frame.maxY))
        
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 3
        shape.path = path.cgPath
        gradientLayer.mask = shape
        layer.addSublayer(gradientLayer)
        shape.strokeEnd = CGFloat(0.0)
    }
    
    
    func setProgress(_ progress: CGFloat) {
        self.shape.strokeEnd = progress
    }
}
