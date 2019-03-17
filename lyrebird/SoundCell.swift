//
//  SoundCell.swift
//  lyrebird
//
//  Created by Robin Diddams on 3/17/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit

class SoundCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
//        alpha = 0.2

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
