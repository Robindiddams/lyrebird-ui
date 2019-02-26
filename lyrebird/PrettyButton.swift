//
//  PrettyButton.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/8/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit

class PrettyButton: UIButton {

//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//        let borderAlpha : CGFloat = 0.7
//        let cornerRadius : CGFloat = 5.0
//
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return
//        }
//        context.clear(rect)
//        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)
//        context.fill(rect)
//        context.setLineWidth(2)
//        context.setStrokeColor(UIColor.white)
//    }
    var borderWidth = 2.0
    var boderColor = UIColor.white.cgColor

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = self.boderColor
//        self.layer.backgroundColor =
        self.layer.borderWidth = CGFloat(self.borderWidth)
    }
}
