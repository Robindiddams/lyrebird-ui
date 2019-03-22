//
//  SoundTableViewCell.swift
//  lyrebird
//
//  Created by Robin Diddams on 3/20/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit
import Pastel

class SoundTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCard()
    }
    
    // MARK: - params
    let defaultBackGroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        if selected {
            UIView.animate(withDuration: 0.3) {
                self.cardView.backgroundColor = UIColor.clear

            }
            
        } else {
            UIView.animate(withDuration: 0.3) {
                self.cardView.backgroundColor = self.defaultBackGroundColor
            }
        }
    }
    
    func setupCard() {
        self.cardView.layer.cornerRadius = 8
//        self.cardView.layer.borderColor = UIColor.white.cgColor
//        self.cardView.layer.borderWidth = 2.0
        self.cardView.clipsToBounds = true
    }
}
