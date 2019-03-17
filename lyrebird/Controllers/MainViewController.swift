//
//  MainViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/25/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCards

private let cellReuseIdentifier = "Cell"
private let headerReuseIdentifier = "Header"

struct lyreSound {
    let name: String
    let task_id: String
    let originalSoundURL: URL
    let lyrebirdSoundURL: URL
}

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tracks: [lyreSound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView!.register(SoundCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.view.setBackgroundGradient()
        self.collectionView.backgroundColor = .clear
        
        self.view.bringSubviewToFront(self.AddButton)
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
        return headerView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SoundCell
        return cell
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var AddButton: UIButton!
    
    @IBAction func addButton(_ sender: UIButton) {
        let s = lyreSound(name: "Beans", task_id: "😅💎", originalSoundURL: URL(fileURLWithPath: ""), lyrebirdSoundURL: URL(fileURLWithPath: ""))
        self.tracks.append(s)
        self.collectionView.reloadData()
        print("tracks: \(tracks.count)")
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
