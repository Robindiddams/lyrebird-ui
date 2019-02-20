//
//  RecorderViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 1/28/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit
import AVFoundation
import Accelerate

enum RecorderState {
    case recording
    case stopped
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
    
    //MARK:- Outlets
    var audioView = Visualizer()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    //MARK:- Actions
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        timeLabel.isHidden = false
        if !self.audioView.isRecording {
            nextButton.isHidden = true
            self.recordButton.setTitle("stop", for: .normal)
            self.checkPermissionAndRecord()
        } else {
            self.stopRecording()
            self.recordButton.setTitle("record", for: .normal)
            nextButton.isHidden = false
        }
    }
    
    private func updateUI(_ recorderState: RecorderState) {
        switch recorderState {
        case .recording:
            self.audioView.isHidden = false
            
            UIApplication.shared.isIdleTimerDisabled = true
            break
        case .stopped:
            self.audioView.isHidden = true
            UIApplication.shared.isIdleTimerDisabled = false
            break
        case .denied:
            UIApplication.shared.isIdleTimerDisabled = false
            self.audioView.isHidden = true
            break
        }
    }
    
    // MARK:- Recording
    private func startRecording() {
        
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
                    self.timeLabel.text = seconds.toTimeString
                    self.renderTs = ts
                    let len = self.audioView.waveforms.count
                    for i in 0 ..< len {
                        let idx = ((frame.count - 1) * i) / len
                        let f: Float = sqrt(1.5 * abs(Float(frame[idx])) / Float(Int16.max))
                        self.audioView.waveforms[i] = min(49, Int(f * 50))
                    }
                    self.audioView.active = !silent
                    self.audioView.setNeedsDisplay()
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
        self.audioView.isRecording = true
        self.updateUI(.recording)
    }
    
    private func stopRecording() {
        self.audioFile = nil
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
        self.audioView.isRecording = false
        self.updateUI(.stopped)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setBackgroundGradient()
        let vHeight: CGFloat = 225
        self.audioView.frame = CGRect(x: 0, y: self.view!.frame.height - vHeight, width: self.view!.frame.width, height: vHeight)
        // Add UIView as a Subview
        self.audioView.isHidden = true
        self.view.addSubview(self.audioView)
        self.view.bringSubviewToFront(self.nextButton)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let a = segue.destination as? UploadViewController {
            a.startUpload()
        }
    }
    
}
