//
//  MainViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/25/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit
import Pastel

private let cellReuseIdentifier = "Cell"
private let headerReuseIdentifier = "Header"

protocol UploadCompletedDelegate {
    func uploadCompleted()
}

struct lyreSound {
    let name: String
    let task_id: String
    let originalSoundURL: URL
    let lyrebirdSoundURL: URL
}

class MainViewController: UIViewController, UploadCompletedDelegate {
    
    var sounds: [lyreSound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRecordings()
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.view.bringSubviewToFront(self.AddButton)
        self.gussyUpButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start fun button animations
        for subview in self.AddButton.subviews {
            if subview.tag == pastelViewTag {
                if let pastelView = subview as? PastelView {
                    pastelView.startAnimation()
                }
            }
        }
    }
    
    // MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var AddButton: UIButton!
    
    // MARK: - Controll
    
    func isPlaying() -> Bool {
        return true
    }
    
    func stopPlay() {
        
    }
    
    // MARK:- Data
    func loadRecordings() {
        self.sounds.removeAll()
        let filemanager = FileManager.default
        let documentsDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let paths = try filemanager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            for path in paths {
                let s = lyreSound(name: String(path.lastPathComponent.split(separator: "-")[0]), task_id: "😅💎", originalSoundURL: path, lyrebirdSoundURL: path)
                self.sounds.append(s)
            }
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    // MARK: - UI mods
    func gussyUpButton() {
        self.AddButton.prettyGradient()
        self.AddButton.layer.cornerRadius = 0.5 * self.AddButton.bounds.size.width
        self.AddButton.clipsToBounds = true
    }
    
    // MARK: - Navigation
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RecorderViewController {
            controller.uploadDelegate = self
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    func uploadCompleted() {
        self.loadRecordings()
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isPlaying() {
            self.stopPlay()
        }
        let sound = self.sounds[indexPath.row]
//        self.play(url: sound.path)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = self.sounds.count
        if result > 0 {
            self.tableView.isHidden = false
        }
        else {
            self.tableView.isHidden = true
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? SoundTableViewCell
        if cell == nil {
            cell = SoundTableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        let sound = self.sounds[indexPath.row]
        cell?.nameLabel?.text = sound.name
        cell?.backgroundColor = .clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let filemanager = FileManager.default
            let sound = self.sounds[indexPath.row]
            do {
//                deleteAudioRecordings(task_id: <#T##String#>)
                self.sounds.remove(at: indexPath.row)
                self.tableView.reloadData()
            } catch (let err) {
                print("Error while deleteing \(err)")
            }
        }
    }
}
