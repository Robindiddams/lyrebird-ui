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
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorTop = UIColor(red: 125.0 / 255.0, green: 199.0 / 255.0, blue: 195 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 46.0 / 255.0, green: 103.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0).cgColor
        let gl = CAGradientLayer()
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.0, 1.0]
        view.backgroundColor = UIColor.clear
        gl.frame = view.frame
        view.layer.insertSublayer(gl, at: 0)

        spinner.color = UIColor.white
        spinner.type = NVActivityIndicatorType.lineScalePulseOutRapid
    }
    
    @IBOutlet weak var spinner: NVActivityIndicatorView!
    @IBOutlet weak var UploadedMessage: UILabel!
    @IBOutlet weak var UploadedCaption: UILabel!
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
                print("status code\(response.response?.statusCode)")
                if response.error == nil, let path = response.destinationURL?.path {
                    print("no error path: \(path)")
                    // TODO(robin): put path in some global thing
                    self.dowloadComplete()
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
                    // wait a few miliseconds to dismiss
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                        UIView.animate(withDuration: 0.3, animations: {
                            hud.textLabel.text = "Success"
                            hud.detailTextLabel.text = nil
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        })
                        hud.dismiss(afterDelay: 1.0)
                        self.uploadComplete()
                    }
                    
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
        UploadedCaption.isHidden = false
        UploadedMessage.isHidden = false
        spinner.startAnimating()
    }
    
    func downloadIsReady(downloadURL: String) {
        self.downloadURL = downloadURL
        spinner.stopAnimating()
        dlButton.isHidden = false
        UploadedMessage.text = "All set!"
        UploadedCaption.text = "slam that download button!"
    }
    
    func dowloadComplete() {
        self.performSegue(withIdentifier: "player", sender: self)
    }
}
