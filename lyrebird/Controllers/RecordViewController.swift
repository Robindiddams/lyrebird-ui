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

enum RecorderState {
    case start
    case canceled
    case finished
    case denied
}


class RecorderViewController: UIViewController {
    
    //MARK:- Properties
    let settings = [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMBitDepthKey: 16, AVLinearPCMIsFloatKey: true, AVSampleRateKey: Float64(44100), AVNumberOfChannelsKey: 1] as [String : Any]
    let audioEngine = AVAudioEngine()
    private var renderTs: Double = 0
    private var recordingTs: Double = 0
    private var silenceTs: Double = 0
    private var audioFile: AVAudioFile?
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setBackgroundGradient()
//        let vHeight: CGFloat = 100
        // use code defined constraints
//        self.audioVisualizer.frame = CGRect(x: 0, y: self.view!.frame.height - vHeight, width: self.view!.frame.width, height: vHeight)
//        self.audioVisualizer.isHidden = true
//        self.view.addSubview(self.audioView)
        self.progressRing.value = 0
        self.progressRing.animationTimingFunction = .linear
    }
    
    //MARK:- Outlets
//    var audioView = Visualizer()
    
    @IBOutlet weak var audioVisualizer: Visualizer!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var progressRing: UICircularProgressRing!
    
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
            self.progressRing.startProgress(to: 100, duration: 10.0) {
                DispatchQueue.main.async {
                    self.stopRecording(.finished)
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                        self.progressRing.alpha = 0.0
                    }, completion: { finished in
                        self.progressRing.resetProgress()
                        self.progressRing.alpha = 1.0
                    })
                }
            }
            self.audioVisualizer.isHidden = false
            self.nextButton.isHidden = true
            self.recordButton.setTitle("cancel", for: .normal)
            UIApplication.shared.isIdleTimerDisabled = true
            break
        case .canceled:
            self.audioVisualizer.isHidden = true
            self.recordButton.setTitle("record", for: .normal)
            self.progressRing.startProgress(to: 0, duration: 0.5)
            UIApplication.shared.isIdleTimerDisabled = false
            break
        case .finished:
            self.nextButton.isHidden = false
            self.audioVisualizer.isHidden = true
            self.recordButton.setTitle("try again", for: .normal)
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
                    let seconds = (ts - self.recordingTs)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let a = segue.destination as? UploadViewController {
            a.startUpload()
        }
    }
    
}
