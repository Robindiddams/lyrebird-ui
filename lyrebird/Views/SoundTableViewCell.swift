//
//  SoundTableViewCell.swift
//  lyrebird
//
//  Created by Robin Diddams on 3/20/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum soundCardState {
    case notDoneYet
    case readyToDownload
    case downloading
    case readyToPlay
    case playing
}

class SoundTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCard()
        self.statusLabel.isHidden = true
        self.backgroundColor = .clear
//        self.cardView.setProgress(1.0)
    }
    
    // MARK: - params
    let defaultBackGroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    var progress: Double = 0.0
    var task_id: String = ""
    
    // MARK: - Outlets
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicatior: NVActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
            UIView.animate(withDuration: 0.3, animations: {
                self.cardView.backgroundColor = UIColor.clear
                
            }, completion: { finished in
                // temporary
                UIView.animate(withDuration: 0.3) {
                    self.cardView.backgroundColor = self.defaultBackGroundColor
                }
            })
        } else {
            UIView.animate(withDuration: 0.3) {
                self.cardView.backgroundColor = self.defaultBackGroundColor
            }
        }
    }
    
    // MARK: - UI Mods
    func setupCard() {
        self.cardView.layer.cornerRadius = 8
        self.cardView.clipsToBounds = true
    }
    
    func finishDownload() {
        self.cardView.setProgress(1.0)
        self.statusLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            UIView.animate(withDuration: 0.3, animations: {
                self.statusLabel.text = "done"
            }, completion: { finished in
                UIView.animate(withDuration: 0.5, animations: {
                    self.statusLabel.alpha = 0
                }, completion: { finished in
                    self.statusLabel.isHidden = true
                    self.statusLabel.alpha = 1
                })
            })
        }
    }
    
    func updateUI(_ state: soundCardState) {
        self.statusLabel.isHidden = true
        self.activityIndicatior.stopAnimating()
        switch state {
        case .notDoneYet:
            self.activityIndicatior.type = .lineScalePulseOutRapid
            self.activityIndicatior.startAnimating()
//            self.statusLabel.isHidden = true
        case .readyToDownload:
            self.statusLabel.text = "tap to download"
            if statusLabel.isHidden {
                self.statusLabel.alpha = 0
                self.statusLabel.isHidden = false
                UIView.animate(withDuration: 0.3, animations:{
                    self.activityIndicatior.alpha = 0
                    self.statusLabel.alpha = 1.0
                }, completion: { finished in
                    self.activityIndicatior.isHidden = true
                    self.activityIndicatior.alpha = 1.0
                    self.activityIndicatior.stopAnimating()
                })
            }
            self.cardView.backgroundColor = .red
        case .downloading:
            self.cardView.setProgress(CGFloat(self.progress))
            self.statusLabel.text = "downloading"
        case .readyToPlay:
            self.cardView.backgroundColor = .blue
        case .playing:
            self.cardView.backgroundColor = .green
        }
    }
}
