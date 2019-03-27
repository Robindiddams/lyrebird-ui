//
//  MainViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/25/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit
import Pastel
import Alamofire
import AHDownloadButton

private let cellReuseIdentifier = "Cell"
private let headerReuseIdentifier = "Header"

protocol UploadCompletedDelegate {
    func uploadCompleted()
}

class MainViewController: UIViewController, UploadCompletedDelegate, AHDownloadButtonDelegate {
    
    var sounds: [lyreSound] = []
    weak var timer: Timer?
    var downloadQueue: [String] = []
    var downloading: Bool = false
    
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
        self.startStatusRequests()
    }
    
    // MARK: - Outlets
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
        self.sounds = getSounds()
        self.tableView.reloadData()
    }
    
    // MARK: - UI mods
    func gussyUpButton() {
        self.AddButton.prettyGradient()
        self.AddButton.layer.cornerRadius = 0.5 * self.AddButton.bounds.size.width
        self.AddButton.clipsToBounds = true
    }
    
    
    // MARK: - Navigation
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RecorderViewController {
            controller.uploadDelegate = self
        }
    }
    
    // MARK: - Networking
    func uploadCompleted() {
        self.loadRecordings()
    }
    
    func startStatusRequests() {
        self.timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        self.timer = Timer.scheduledTimer(withTimeInterval:  3.0, repeats: true) { [weak self] _ in
            if self == nil {
                return
            }
            // Every 10 seconds ask server if it's done
            var task_ids = [String]()
            for sound in self!.sounds {
                if self!.objectiveState(sound) == .notDoneYet {
                    task_ids.append(sound.task_id)
                }
            }
            if task_ids.isEmpty {
                return
            }
            // Hit status api
            let parameters: Parameters = [
                "task_ids": task_ids,
            ]
            Alamofire.request(apiURL + "/status", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                // Check for errors
                if let data = response.result.value {
                    do {
                        let decoder = JSONDecoder()
                        if response.response?.statusCode != 200 {
                            let errorRez = try decoder.decode(ErrorResponse.self, from: data)
                            print("error: \(errorRez.message)")
                            return
                        }
                        let rez = try decoder.decode(StatusResponse.self, from: data)
                        print("success: \(rez.success)")
                        for task in rez.tasks {
                            if task.completed {
                                for (index, sound) in self!.sounds.enumerated() {
                                    if sound.task_id == task.task_id {
                                        self!.sounds[index].downloadURL = task.download_url
                                    }
                                }
                            }
                        }
                        self!.tableView.reloadData()
                    } catch let parsingError {
                        print("status parsingError: \(parsingError)")
                    }
                } else {
                    // NO DATA does this even happen?
                    print("the unthinkable happenned")
                }
            }
        }
    }
    
    func stopStatusRequests() {
        self.timer?.invalidate()
    }
    
    func indexForTaskID(_ task_id: String) -> Int? {
        for (index, sound) in self.sounds.enumerated() {
            if task_id == sound.task_id {
                return index
            }
        }
        return nil
    }
    
    func downloadSound(task_id: String)->Void{
        // check that it's there
        if let index = indexForTaskID(task_id), let url = self.sounds[index].downloadURL {
            self.sounds[index].downloadProgress = 0.001
            // Get destination of download
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let fileURL = getSoundURL(id: task_id)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
//            let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0))
            // Start download
            Alamofire.download(url, to: destination)
                .downloadProgress { progress in
                    print("download progress: \(progress.fractionCompleted)")
                    self.sounds[index].downloadProgress = progress.fractionCompleted
                    self.tableView.reloadData()
                }
                .response { response in // Download complete
                    self.sounds[index].downloadProgress = 1.0
                    self.tableView.reloadData()
                    // Get path for downloaded file
                    if response.error == nil, let pathURL = response.destinationURL {
                        print("path: \(pathURL.path)")
                        self.sounds[index].lyrebirdSoundURL = pathURL
                        // wait a few miliseconds to dismiss
                        for c in self.tableView.visibleCells {
//                            if cell.
                            if let soundCell = c as? SoundTableViewCell, soundCell.task_id == task_id {
                                print("it was visible")
                                soundCell.finishDownload()
                            }
                        }
                    } else {
                        // Error downloading
                        if response.response?.statusCode != 200 {
                            print("status code\(response.response!.statusCode)")
                        }
                        print("status there was an error downloading the web audio")
                    }
            }
        }
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func objectiveState(_ sound: lyreSound) -> soundCardState {
        if sound.lyrebirdSoundURL == nil {
            // check if we have a download URL
            if sound.downloadURL != nil {
                if sound.downloadProgress > 0 {
                    // we are downloading
                    return soundCardState.downloading
                }
                // we are ready to download
                return soundCardState.readyToDownload
            } else {
                // we need a download URL
                return soundCardState.notDoneYet
            }
        } else {
            
            // we have both sounds we are good
            return soundCardState.readyToPlay
            // TODO: check if this cell is playing
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = self.sounds[indexPath.row]
        let state = objectiveState(sound)
        if state == .readyToDownload {
            print("downloading \(sound.task_id)")
            self.downloadSound(task_id: sound.task_id)
        }
//        if self.isPlaying() {
//            self.stopPlay()
//        }
//        let sound = self.sounds[indexPath.row]
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
        cell?.task_id = sound.task_id
        let state = objectiveState(sound)
        if state == .downloading {
            cell?.progress = sound.downloadProgress
        }
        cell?.updateUI(state)
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let filemanager = FileManager.default
//            let sound = self.sounds[indexPath.row]
//            do {
////                deleteAudioRecordings(task_id: <#T##String#>)
//                self.sounds.remove(at: indexPath.row)
//                self.tableView.reloadData()
//            } catch (let err) {
//                print("Error while deleteing \(err)")
//            }
//        }
//    }
}
