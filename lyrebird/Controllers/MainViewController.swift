//
//  ViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 11/29/18.
//  Copyright © 2018 Robin Diddams. All rights reserved.
//
import UIKit

class MainViewController: UIViewController {
    
    //MARK:- Properties
    private var recorderViewController: RecorderViewController? {
        get {
            return children.compactMap({ $0 as? RecorderViewController }).first
        }
    }
    
    //MARK:- Outlets
    @IBOutlet weak var recorderView: UIView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let recorder = self.recorderViewController {
            recorder.delegate = self
        }
        
    }
    
}

extension MainViewController: RecorderViewControllerDelegate {
    func didStartRecording() {
        print("started")
//        if let recordings = self.recordingsViewController {
//            recordings.fadeView.isHidden = false
//            UIView.animate(withDuration: 0.25, animations: {
//                recordings.fadeView.alpha = 1
//            })
//        }
    }

    func didFinishRecording() {
        print("stopped")
//        if let recordings = self.recordingsViewController {
//            recordings.view.isUserInteractionEnabled = true
//            UIView.animate(withDuration: 0.25, animations: {
//                recordings.fadeView.alpha = 0
//            }, completion: { (finished) in
//                if finished {
//                    recordings.fadeView.isHidden = true
//                    DispatchQueue.main.async {
//                        recordings.loadRecordings()
//                    }
//                }
//            })
//        }
    }
}
