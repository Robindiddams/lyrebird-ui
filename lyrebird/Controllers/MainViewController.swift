//
//  MainViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/25/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//
/*
 Some code stolen from github.com/HassanElDesouky/VoiceMemosClone, here's their license
 MIT License
 
 Copyright (c) 2019 Hassan El Desouky
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import Pastel
import Alamofire
import AVFoundation

private let cellReuseIdentifier = "Cell"
//private let headerReuseIdentifier = "Header"
let mainBackgroundColor = UIColor(r: 42, g: 40, b: 63)

protocol UploadCompletedDelegate {
    func uploadCompleted()
}


class MainViewController: UIViewController, UploadCompletedDelegate, AVAudioPlayerDelegate {
    
    var sounds: [lyreSound] = []
    weak var timer: Timer?
    var downloadQueue: [String] = []
    var downloading: Bool = false
    var currentlyPlaying: String = ""
    private var midiPlayer: AVMIDIPlayer?
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        do {
//            try AVAudioSession.sharedInstance().setActive(false)
//        } catch  let error as NSError {
//            print(error.localizedDescription)
//            return
//        }
        self.stopPlay()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var AddButton: UIButton!
    
    // MARK: - Controll
    // MARK:- Playback
    private func play(url: URL) {
        guard let soundfont = Bundle.main.url(forResource: "GeneralUser_GS_v1.471", withExtension: "sf2") else {
            print("could not find soundfonts")
            return
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            self.midiPlayer = try AVMIDIPlayer(data: data, soundBankURL: soundfont)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        if let player = self.midiPlayer {
            player.prepareToPlay()
            player.play()
        }
    }
    
    func clearPlaying() {
        for c in self.tableView.visibleCells {
            if let soundCell = c as? SoundTableViewCell, soundCell.task_id == self.currentlyPlaying {
                soundCell.updateUI(.readyToPlay)
                print("clearplaying \(soundCell.task_id)")
            }
        }
        self.currentlyPlaying = ""
    }
    
    func stopPlay() {
        self.clearPlaying()
        if let paths = self.tableView.indexPathsForSelectedRows {
            for path in paths {
                self.tableView.deselectRow(at: path, animated: true)
            }
        }
        if let player = self.midiPlayer {
            player.stop()
        }
        self.midiPlayer = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
    }
    
    private func isPlaying() -> Bool {
        if let player = self.midiPlayer {
            return player.isPlaying
        }
        return false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.clearPlaying()
    }
    
    // MARK:- Data
    func loadRecordings() {
        self.sounds.removeAll()
        self.sounds = getSounds()
        self.sounds.sort() { $0.createdAtDate! > $1.createdAtDate! }
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
//                        print("data \(String(decoding: response.data!, as: UTF8.self))")
                        let rez = try decoder.decode(StatusResponse.self, from: data)
                        print("status success: \(rez.success)")
                        for task in rez.tasks {
                            if task.status == "done" {
                                for (index, sound) in self!.sounds.enumerated() {
                                    if sound.task_id == task.task_id {
                                        self!.sounds[index].downloadURL = task.download_url
                                        for c in self!.tableView.visibleCells {
                                            if let soundCell = c as? SoundTableViewCell, soundCell.task_id == task.task_id {
                                                soundCell.updateUI(.readyToDownload)
                                            }
                                        }
                                    }
                                }
                            }
                        }
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
            // Start download
            Alamofire.download(url, to: destination)
                .downloadProgress { progress in
                    print("download progress: \(progress.fractionCompleted)")
                    self.sounds[index].downloadProgress = progress.fractionCompleted
                    for c in self.tableView.visibleCells {
                        if let soundCell = c as? SoundTableViewCell, soundCell.task_id == task_id {
                            soundCell.progress = self.sounds[index].downloadProgress
                            soundCell.updateUI(.downloading)
                        }
                    }
                }
                .response { response in // Download complete
                    self.sounds[index].downloadProgress = 1.0
                    for c in self.tableView.visibleCells {
                        if let soundCell = c as? SoundTableViewCell, soundCell.task_id == task_id {
                            soundCell.progress = self.sounds[index].downloadProgress
                            soundCell.updateUI(.downloading)
                        }
                    }
                    // Get path for downloaded file
                    if response.error == nil, let pathURL = response.destinationURL {
                        self.sounds[index].lyrebirdSoundURL = pathURL
                        // wait a few miliseconds to dismiss
                        for c in self.tableView.visibleCells {
                            if let soundCell = c as? SoundTableViewCell, soundCell.task_id == task_id {
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
            
            if sound.task_id == self.currentlyPlaying {
                return soundCardState.playing
            }
            // we have both sounds we are good to play
            return soundCardState.readyToPlay
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = self.sounds[indexPath.row]
        let state = objectiveState(sound)
        if state == .readyToDownload {
            print("downloading \(sound.task_id)")
            self.downloadSound(task_id: sound.task_id)
        } else if state == .readyToPlay {
            if self.isPlaying() {
                self.stopPlay()
            }
            self.currentlyPlaying = sound.task_id
            for c in self.tableView.visibleCells {
                if let soundCell = c as? SoundTableViewCell, soundCell.task_id == sound.task_id {
                    soundCell.updateUI(.playing)
                }
            }
            self.play(url: sound.lyrebirdSoundURL!)
        } else if state == .playing {
            self.stopPlay()
        }
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
        cell?.nameLabel.text = sound.name
        cell?.task_id = sound.task_id
        cell?.dateLabel.text = dateFormatter.string(from: sound.createdAtDate!)
        let state = objectiveState(sound)
        if state == .downloading {
            cell?.progress = sound.downloadProgress
        }
        cell?.updateUI(state)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let sound = self.sounds[indexPath.row]
            if self.isPlaying() {
                self.stopPlay()
            }
            deleteAudioRecordings(task_id: sound.task_id)
            self.loadRecordings()
        }
//        deleteButton.backgroundColor = mainBackgroundColor
        return [deleteButton]
    }
}
