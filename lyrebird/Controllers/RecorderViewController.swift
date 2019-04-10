//
//  RecorderViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 1/28/19.
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
import Accelerate
import UICircularProgressRing
import JGProgressHUD
import Alamofire
import CryptoSwift

enum RecorderState {
    case start
    case canceled
    case finished
    case denied
    case error
}

let redColorSet = [UIColor(r: 245, g: 78, b: 162).cgColor, UIColor(r: 255, g: 118, b: 118).cgColor]
let greenColorSet = [UIColor(r: 59, g: 178, b: 184).cgColor, UIColor(r: 36, g: 240, b: 149).cgColor]


class RecorderViewController: UIViewController {
    
    //MARK:- Properties
    let settings = [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMBitDepthKey: 16, AVLinearPCMIsFloatKey: true, AVSampleRateKey: Float64(44100), AVNumberOfChannelsKey: 1] as [String : Any]
    let audioEngine = AVAudioEngine()
    private var renderTs: Double = 0
    private var recordingTs: Double = 0
    private var silenceTs: Double = 0
    private var audioFile: AVAudioFile?
    var task_id: String = ""
    let hud: JGProgressHUD = JGProgressHUD(style: .dark)
    
    var uploadDelegate: UploadCompletedDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordButton.setGradient(colors: redColorSet)
        self.nextButton.setGradient(colors: greenColorSet)
        self.progressRing.value = 0
        self.progressRing.animationTimingFunction = .linear
    }
    
    //MARK:- Outlets
    @IBOutlet weak var audioVisualizer: Visualizer!
    @IBOutlet weak var nextButton: PrettyButton!
    @IBOutlet weak var recordButton: PrettyButton!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    //MARK:- Actions
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if !self.audioVisualizer.isRecording {
            self.checkPermissionAndRecord()
        } else {
            self.stopRecording()
        }
    }
    
    private func updateUI(_ recorderState: RecorderState) {
        switch recorderState {
        case .start:
            self.progressRing.startProgress(to: 100, duration: 5.0) {
                DispatchQueue.main.async {
                    self.stopRecording(.finished)
                    UIView.animate(withDuration: 0.1, delay: 0.0, animations: {
                        self.progressRing.alpha = 0.0
                    }, completion: { finished in
                        UIView.animate(withDuration: 0.3) {
                            self.progressRing.isHidden = true
                            self.nextButton.isHidden = false
                        }
                        self.progressRing.resetProgress()
                        self.progressRing.alpha = 1.0
                    })
                }
            }
            self.audioVisualizer.isHidden = false
            if self.nextButton.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.progressRing.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.text = "One more time!"
                    self.subTitleLabel.text = "you can even record your farts!👍"
                    self.nextButton.alpha = 0.0
                }, completion: { finished in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.nextButton.isHidden = true
                        self.progressRing.isHidden = false
                    }, completion: { finished in
                        self.nextButton.alpha = 1.0
                    })
                    
                })
            }
            self.recordButton.setTitle("cancel", for: .normal)
            UIApplication.shared.isIdleTimerDisabled = true
            break
        case .canceled:
            self.audioVisualizer.isHidden = true
            self.recordButton.setTitle("Start", for: .normal)
            self.progressRing.startProgress(to: 0, duration: 0.5) {
                UIView.animate(withDuration: 0.3) {
                    self.progressRing.isHidden = true
                }
            }
            UIApplication.shared.isIdleTimerDisabled = false
            break
        case .finished:
            self.audioVisualizer.isHidden = true
            self.recordButton.setTitle("try again", for: .normal)
            self.nextButton.setTitle("upload", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.text = "Yeah, cool, whatever!"
                self.subTitleLabel.text = "just hit upload! what do you got to lose?"
            }
            UIApplication.shared.isIdleTimerDisabled = false
            break
        case .error:
            self.audioVisualizer.isHidden = true
            self.recordButton.setTitle("re-record", for: .normal)
            self.nextButton.setTitle("retry", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.text = "Uh oh!😰"
                self.subTitleLabel.text = "Upload failed! Make sure you're connected to the internet and try agian."
            }
            UIApplication.shared.isIdleTimerDisabled = false
            break
        case .denied:
            UIApplication.shared.isIdleTimerDisabled = false
            self.audioVisualizer.isHidden = true
            break
        }
    }
    
    // MARK:- Recording
    private func startRecording(_ recorderState: RecorderState = .start) {
        self.recordingTs = NSDate().timeIntervalSince1970
        self.silenceTs = 0
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        
        let inputNode = self.audioEngine.inputNode
        guard let format = self.format() else {
            return
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer, time) in
            let level: Float = -50
            let length: UInt32 = 1024
            buffer.frameLength = length
            let channels = UnsafeBufferPointer(start: buffer.floatChannelData, count: Int(buffer.format.channelCount))
            var value: Float = 0
            vDSP_meamgv(channels[0], 1, &value, vDSP_Length(length))
            var average: Float = ((value == 0) ? -100 : 20.0 * log10f(value))
            if average > 0 {
                average = 0
            } else if average < -100 {
                average = -100
            }
            let silent = average < level
            let ts = NSDate().timeIntervalSince1970
            if ts - self.renderTs > 0.1 {
                let floats = UnsafeBufferPointer(start: channels[0], count: Int(buffer.frameLength))
                let frame = floats.map({ (f) -> Int in
                    return Int(f * Float(Int16.max))
                })
                DispatchQueue.main.async {
                    self.renderTs = ts
                    let len = self.audioVisualizer.waveforms.count
                    for i in 0 ..< len {
                        let idx = ((frame.count - 1) * i) / len
                        let f: Float = sqrt(1.5 * abs(Float(frame[idx])) / Float(Int16.max))
                        self.audioVisualizer.waveforms[i] = min(49, Int(f * 50))
                    }
                    self.audioVisualizer.active = !silent
                    self.audioVisualizer.setNeedsDisplay()
                }
            }
            
            let write = true
            if write {
                if self.audioFile == nil {
                    self.audioFile = self.createAudioRecordFile()
                }
                if let f = self.audioFile {
                    do {
                        try f.write(from: buffer)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        do {
            self.audioEngine.prepare()
            try self.audioEngine.start()
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        self.audioVisualizer.isRecording = true
        self.updateUI(recorderState)
    }
    
    private func stopRecording(_ recorderState: RecorderState = .canceled) {
        self.audioFile = nil
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
        self.audioVisualizer.isRecording = false
        self.updateUI(recorderState)
    }
    
    private func checkPermissionAndRecord() {
        let permission = AVAudioSession.sharedInstance().recordPermission
        switch permission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (result) in
                DispatchQueue.main.async {
                    if result {
                        self.startRecording()
                    }
                    else {
                        self.updateUI(.denied)
                    }
                }
            })
            break
        case .granted:
            self.startRecording()
            break
        case .denied:
            self.updateUI(.denied)
            break
        @unknown default:
            self.updateUI(.denied)
        }
    }
    
    private func isRecording() -> Bool {
        if self.audioEngine.isRunning {
            return true
        }
        return false
    }
    
    private func format() -> AVAudioFormat? {
        let format = AVAudioFormat(settings: self.settings)
        return format
    }
    
    
    // MARK:- Paths and files
    
    private func createAudioRecordFile() -> AVAudioFile? {
        let path = getAudioRecordPath()
        do {
            let file = try AVAudioFile(forWriting: path, settings: self.settings, commonFormat: .pcmFormatFloat32, interleaved: true)
            return file
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // MARK:- Handle interruption
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let key = userInfo[AVAudioSessionInterruptionTypeKey] as? NSNumber
            else { return }
        if key.intValue == 1 {
            DispatchQueue.main.async {
                if self.isRecording() {
                    self.stopRecording()
                }
            }
        }
    }
    
    // MARK:- Networking
    @IBAction func startUpload(_ sender: PrettyButton) {
        // Setup hud modal
        self.hud.vibrancyEnabled = true
        self.hud.indicatorView = JGProgressHUDPieIndicatorView()
        self.hud.textLabel.text = "Uploading..."
        self.hud.show(in: self.view)
        var seed = 0
        do {
            let fileData = try Data(contentsOf: getAudioRecordPath())
            seed = fileData.bytes.hashValue
        } catch let error {
            print("does this happen: \(error)")
        }
        let smallseed = (seed >> 10) & 0xffff
        let parameters: Parameters = [
            "seed": smallseed,
        ]
        // get our upload url
        Alamofire.request(apiURL + "/upload", method: .get, parameters: parameters)
            .responseData { response in
                if let data = response.result.value {
                    do {
                        let decoder = JSONDecoder()
                        if response.response?.statusCode != 200 {
                            
                            // TODO: do something on errors, show error and go back
                            print("error \(data.base64EncodedString())")
                            let errorRez = try decoder.decode(ErrorResponse.self, from: data)
                            print("ERROR: success: \(errorRez.success), message: \(errorRez.message)")
                            UIView.animate(withDuration: 0.5, animations: {
                                self.hud.textLabel.text = "Error!"
                                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                            }, completion: { finished in
                                self.updateUI(.error)
                            })
                            self.hud.dismiss(afterDelay: 1.0)
                            return
                        }
                        let resp = try decoder.decode(UploadResponse.self, from: data)
                        print("success: \(resp.success), task: \(resp.task_id)")
                        self.task_id = resp.task_id
                        self.hud.setProgress(1.0, animated: true)
                        renameAudioRecord(task_id: resp.task_id)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                            UIView.animate(withDuration: 0.5, animations: {
                                self.hud.textLabel.text = "Success!"
                                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                            }, completion: { finished in
                                // Go to waiting state
                                self.hud.dismiss(afterDelay: 1.0)
                                self.uploadComplete()
                            })
                        }
                       
                    } catch let parseError {
                        print("upload parsingError: \(parseError)")
                    }
                }
        }
    }
    
    func uploadComplete() {
        self.uploadDelegate.uploadCompleted()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.performSegue(withIdentifier: "goHome", sender: self)
        }
    }
}
