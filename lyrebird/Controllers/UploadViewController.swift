//
//  UploadViewController.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/7/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
import Alamofire

let apiURL = "https://p00plqfrp6.execute-api.us-east-1.amazonaws.com/dev"

enum networkState {
    case connecting
    case uploading
    case waiting
    case downloadReady
    case downloading
}

class UploadViewController: UIViewController {

    var task_id: String = ""
    var downloadURL: String = ""
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setBackgroundGradient()
        spinner.type = NVActivityIndicatorType.orbit
        spinner.startAnimating()
    }
    
    func updateUI(_ state: networkState) {
        switch state {
        case .connecting:
            spinner.type = NVActivityIndicatorType.orbit
            spinner.startAnimating()
            self.dlButton.fadeTransition(0.2)
            dlButton.isHidden = false
            self.TitleLabel.fadeTransition(0.2)
            self.TitleLabel.text = "Connecting..."
            self.SubtitleLabel.fadeTransition(0.2)
            self.SubtitleLabel.text = "give us a sec to connect to the lyrebird cloud"
            break
        case .uploading:
            self.TitleLabel.fadeTransition(0.2)
            self.TitleLabel.isHidden = true
            self.SubtitleLabel.fadeTransition(0.2)
            self.SubtitleLabel.isHidden = true
            self.spinner.stopAnimating()
            break
        case .waiting:
            self.TitleLabel.text = "It's up there!"
            self.SubtitleLabel.text = "lyrebird is generating your song"
            self.TitleLabel.fadeTransition(0.2)
            self.TitleLabel.isHidden = false
            self.SubtitleLabel.fadeTransition(0.2)
            self.SubtitleLabel.isHidden = false
            spinner.type = NVActivityIndicatorType.lineScalePulseOutRapid
            spinner.startAnimating()
            break
        case .downloadReady:
            spinner.stopAnimating()
            self.dlButton.fadeTransition(0.2)
            dlButton.isHidden = false
            self.TitleLabel.fadeTransition(0.2)
            self.TitleLabel.text = "All set!"
            self.SubtitleLabel.fadeTransition(0.2)
            self.SubtitleLabel.text = "slam that download button!"
        case .downloading:
            break
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!
    @IBOutlet weak var dlButton: UIButton!
    
    
    // MARK: Actions
    @IBAction func startDownload(_ sender: UIButton) {
        // Setup hud modal
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = true
        hud.progress = 0.0
        hud.textLabel.text = "Downloading"
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.show(in: self.view)
        
        // Get destination of download
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = getSoundURL(name: self.task_id)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        // Start download
        Alamofire.download(self.downloadURL, to: destination)
            .downloadProgress { progress in // Update hud with progress
                let currentProgress = Float(progress.fractionCompleted * 100.0)
                print("download progress: \(String(format: "%.2f", currentProgress))% \(progress.fractionCompleted)")
                hud.detailTextLabel.text = "\(String(format: "%.2f", currentProgress))% Complete"
                hud.setProgress(Float(progress.fractionCompleted), animated: true)
            }
            .response { response in // Download complete

                // Get path for downloaded file
                if response.error == nil, let pathURL = response.destinationURL {
                    print("path: \(pathURL.path)")
                    // wait a few miliseconds to dismiss
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                        UIView.animate(withDuration: 0.3, animations: {
                            hud.textLabel.text = "Success"
                            hud.detailTextLabel.text = nil
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        })
                        hud.dismiss(afterDelay: 1.0)
                        self.dowloadComplete()
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
    
    func startStatusRequests() {
        self.timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            // Every 10 seconds ask server if it's done
            if let tID = self?.task_id { // this might be unnessesary
                // Hit status api
                let parameters: Parameters = ["task_id": tID]
                Alamofire.request(apiURL + "/status", parameters: parameters).responseJSON { response in
                    // Check for errors
                    if response.response?.statusCode != 200 {
                        if let json = response.result.value as? [String: Any], let resp = errorResponse(json: json) {
                            // TODO: do something on errors
                            print("ERROR: success: \(resp.success), message: \(resp.message)")
                            return
                        }
                    }
                    if let json = response.result.value as? [String: Any], let resp = statusResponse(json: json) {
                        print("success: \(resp.success), task: \(resp.completed), url: \(resp.URL)")
                        if resp.completed {
                            self?.stopStatusRequests()
                            self?.downloadIsReady(downloadURL: resp.URL)
                        }
                    }
                }
            }
        }
    }
    
    func stopStatusRequests() {
        self.timer?.invalidate()
    }
    
    func uploadRecording(url: String) {
        
        // Update UI
        self.updateUI(.uploading)
        
        // Setup hud modal
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = true
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.detailTextLabel.text = "0% Complete"
        hud.textLabel.text = "Uploading"
        hud.show(in: self.view)
        
        // Get recording
        if let encodedMusic = try? Data(contentsOf: getSoundURL(name: self.task_id, recording: true)) {
            let headers: HTTPHeaders = [
                "Content-Type": "application/octet-stream"
            ]
            
            // Begin Upload
            Alamofire.upload(encodedMusic, to: url, method: .put, headers: headers)
                .uploadProgress { progress in // Update Hud with progress
                    let currentProgress = Float(progress.fractionCompleted * 100.0)
                    print("upload progress: \(String(format: "%.2f", currentProgress))% \(progress.fractionCompleted)")
                    hud.detailTextLabel.text = "\(String(format: "%.2f", currentProgress))% Complete"
                    hud.setProgress(Float(progress.fractionCompleted), animated: true)
                }
                .response { response in // Completed upload
                    // Its weird when we get to 87% and then complete
                    if hud.progress < 1.0 {
                        hud.detailTextLabel.text = "100.0% Complete"
                        hud.setProgress(1.0, animated: true)
                    }
                    
                    // Check for errors
                    if response.response?.statusCode != 200 {
                        print("error \(response.response?.statusCode)")
                        if let data = response.data {
                            print("data:\(data.base64EncodedString())")
                        }
                        // TODO: throw an error, tell user
                        return
                    }
                    
                    // Go to waiting state
                    UIView.animate(withDuration: 0.3, animations: {
                        hud.textLabel.text = "Success"
                        hud.detailTextLabel.text = nil
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    })

                    hud.dismiss(afterDelay: 1.0)
                    self.uploadComplete()
            }
        } else {
            // TODO: throw an error, tell user and go back to record
        }
        
    }

    func startUpload() {
        // get our upload url
        Alamofire.request(apiURL + "/upload")
            .responseJSON { response in
                print("success: \(response.result.isSuccess)")
                if response.response?.statusCode != 200 {
                    if let json = response.result.value as? [String: Any], let resp = errorResponse(json: json) {
                        // TODO: do something on errors, show error and go back
                        print("ERROR: success: \(resp.success), message: \(resp.message)")
                        return
                    }
                }
                if let json = response.result.value as? [String: Any], let resp = uploadResponse(json: json) {
                    print("success: \(resp.success), task: \(resp.task_id), upload_url: \(resp.URL)")
                    self.task_id = resp.task_id
                    renameAudioRecord(task_id: resp.task_id)
                    self.uploadRecording(url: resp.URL)
                }
        }
    }
    
    func uploadComplete() {
        // Update UI
        self.updateUI(.waiting)
        
        // Start requesting server for download
        self.startStatusRequests()
    }
    
    func downloadIsReady(downloadURL: String) {
        // Update UI
        self.updateUI(.downloadReady)
        self.downloadURL = downloadURL
    }
    
    func dowloadComplete() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.performSegue(withIdentifier: "player", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let player = segue.destination as? PlayerViewController {
            player.task_id = self.task_id
        }
    }
}
