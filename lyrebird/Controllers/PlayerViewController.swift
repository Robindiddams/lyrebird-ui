//
//  PlayerViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/8/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

/*
 Some code adapted from github.com/HassanElDesouky/VoiceMemosClone, here's their license
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
import AVFoundation

class PlayerViewController: UIViewController {
    
    private var audioPlayer: AVAudioPlayer?
    var soundPath: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setBackgroundGradient()
    }
    
    @IBOutlet weak var playpauseButton: UIButton!
    @IBAction func playpausepressed(_ sender: UIButton) {
        if self.isPlaying() {
            // pause
            self.stopPlay()
        } else {
            // play
            self.play(url: self.soundPath)
        }
    }
    
    // MARK:- Playback
    private func play(url: URL) {
        playpauseButton.setTitle("stop", for: .normal)
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            self.audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.caf.rawValue)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        if let player = self.audioPlayer {
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        }
    }
    
    func stopPlay() {
        self.playpauseButton.setTitle("play", for: .normal)
        if let player = self.audioPlayer {
            player.pause()
        }
        self.audioPlayer = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
    }
    
    private func isPlaying() -> Bool {
        if let player = self.audioPlayer {
            return player.isPlaying
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print(e.localizedDescription)
        }
        self.stopPlay()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlay()
    }
}
