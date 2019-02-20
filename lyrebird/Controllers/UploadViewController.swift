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

class UploadViewController: UIViewController {

    var task_id: String = ""
    var downloadURL: String = ""
    var downloadedSoundURL: URL!
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setBackgroundGradient()
        spinner.color = UIColor.white
        spinner.type = NVActivityIndicatorType.orbit
        spinner.startAnimating()
    }
    
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!
    @IBOutlet weak var dlButton: UIButton!
    
    @IBAction func startDownload(_ sender: UIButton) {
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = true
        hud.progress = 0.0
        hud.textLabel.text = "Downloading"
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.show(in: self.view)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let fileURL = getSoundPath(name: self.task_id)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(self.downloadURL, to: destination)
            .downloadProgress { progress in
                let currentProgress = Float(progress.fractionCompleted * 100.0)
                print("download progress: \(String(format: "%.2f", currentProgress))% \(progress.fractionCompleted)")
                hud.detailTextLabel.text = "\(String(format: "%.2f", currentProgress))% Complete"
                hud.setProgress(Float(progress.fractionCompleted), animated: true)
            }
            .response { response in
//                print("status code\(response.response?.statusCode)")
                if response.error == nil, let pathURL = response.destinationURL {
                    print("no error path: \(pathURL.path)")
                    // wait a few miliseconds to dismiss
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                        UIView.animate(withDuration: 0.3, animations: {
                            hud.textLabel.text = "Success"
                            hud.detailTextLabel.text = nil
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        })
                        hud.dismiss(afterDelay: 1.0)
                        self.downloadedSoundURL = pathURL
                        self.dowloadComplete()
                    }
                }
            }
    }
    
    func startStatusRequests() {
        self.timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        self.timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            if let tID = self?.task_id {
                Alamofire.request(apiURL + "/status?task_id=\(tID)").responseJSON { response in
                    if response.response?.statusCode != 200 {
                        if let json = response.result.value as? [String: Any], let resp = errorResponse(json: json) {
                            // TODO: do something on errors
                            print("ERROR: success: \(resp.success), message: \(resp.message)")
                            return
                        }
                    }
//                    print("Success: \(response.result.isSuccess) code:\(response.response?.statusCode)")
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
    
    func UploadRecording(url: String) {
        self.spinner.stopAnimating()
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = true
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.detailTextLabel.text = "0% Complete"
        hud.textLabel.text = "Uploading"
        hud.show(in: self.view)
        if let encodedMusic = try? Data(contentsOf: getAudioRecordPath()) {
            let headers: HTTPHeaders = [
                "Content-Type": "application/octet-stream"
            ]
            Alamofire.upload(encodedMusic, to: url, method: .put, headers: headers)
                .uploadProgress { progress in // main queue by default
                    let currentProgress = Float(progress.fractionCompleted * 100.0)
                    print("upload progress: \(String(format: "%.2f", currentProgress))% \(progress.fractionCompleted)")
                    hud.detailTextLabel.text = "\(String(format: "%.2f", currentProgress))% Complete"
                    hud.setProgress(Float(progress.fractionCompleted), animated: true)
                }
                .response { response in
                    if hud.progress < 1.0 {
                        hud.detailTextLabel.text = "100.0% Complete"
                        hud.setProgress(1.0, animated: true)
                    }
                    if response.response?.statusCode != 200 {
                        print("error \(response.response?.statusCode)")
                        if let data = response.data {
                            print("data:\(data.base64EncodedString())")
                        }
                        // TODO: throw an error, tell user
                        return
                    }
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
                    self.UploadRecording(url: resp.URL)
                }
        }
    }
    
    func uploadComplete() {
        // Delete local recording
        deleteAudioRecording()
        
        // Start requesting server for download
        self.startStatusRequests()
        
        // Show new UI elements
        self.TitleLabel.fadeTransition(0.2)
        self.TitleLabel.text = "It's up there!"
        self.SubtitleLabel.fadeTransition(0.2)
        self.SubtitleLabel.text = "lyrebird is generating your song"
        spinner.type = NVActivityIndicatorType.lineScalePulseOutRapid
        spinner.startAnimating()
    }
    
    func downloadIsReady(downloadURL: String) {
        self.downloadURL = downloadURL
        spinner.stopAnimating()
        self.dlButton.fadeTransition(0.2)
        dlButton.isHidden = false
        self.TitleLabel.fadeTransition(0.2)
        self.TitleLabel.text = "All set!"
        self.SubtitleLabel.fadeTransition(0.2)
        self.SubtitleLabel.text = "slam that download button!"
    }
    
    func dowloadComplete() {
        // wait a few miliseconds to dismiss
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
            player.soundPath = self.downloadedSoundURL;
        }
    }
}
