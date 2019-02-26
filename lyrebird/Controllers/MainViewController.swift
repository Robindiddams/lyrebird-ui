//
//  MainViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/25/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setBackgroundGradient()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
