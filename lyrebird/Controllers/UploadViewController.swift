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

let apiURL = "https://67j3dw6bhb.execute-api.us-east-1.amazonaws.com/dev"

class UploadViewController: UIViewController {

    var task_id: String = ""
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
        self.incrementHUD(hud, progress: 0)
    }
    
    func startStatusRequests() {
        timer?.invalidate()   // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
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
                        print("success: \(resp.success), task: \(resp.completed)")
                        if resp.completed {
                            self?.stopStatusRequests()
                            self?.downloadIsReady()
                        }
                    }
                }
            }
        }
    }
    
    func stopStatusRequests() {
        timer?.invalidate()
    }

    
    func startUpload() {
        let hud = JGProgressHUD(style: .light)
        hud.vibrancyEnabled = true
        hud.indicatorView = JGProgressHUDPieIndicatorView()
        hud.detailTextLabel.text = "0% Complete"
        hud.textLabel.text = "Uploading"
        hud.show(in: self.view)
        
        var encodedString: Data = Data()
        if let encodedMusic = try? Data(contentsOf: getAudioRecordPath()) {
            encodedString = encodedMusic.base64EncodedData()
        } else {
            // TODO: throw an error
        }
        
        
        Alamofire.upload(encodedString, to: apiURL + "/upload")
            .uploadProgress { progress in // main queue by default
                let currentProgress = Float(progress.fractionCompleted * 100.0)
                print("upload progress: \(String(format: "%.2f", currentProgress)) \(currentProgress)")
                hud.detailTextLabel.text = "\(String(format: "%.2f", currentProgress))% Complete"
                hud.setProgress(currentProgress, animated: true)
            }
            .responseJSON { response in
                // wait a few miliseconds to dismiss
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                    UIView.animate(withDuration: 0.3, animations: {
                        hud.textLabel.text = "Success"
                        hud.detailTextLabel.text = nil
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    })
                    hud.dismiss(afterDelay: 1.0)
                    if response.result.value is NSNull {
                        // TODO do something here too
                        return
                    }
                    if response.response?.statusCode != 200 {
                        if let json = response.result.value as? [String: Any], let resp = errorResponse(json: json) {
                            // TODO: do something on errors
                            print("ERROR: success: \(resp.success), message: \(resp.message)")
                            return
                        }
                    }
                    if let json = response.result.value as? [String: Any], let resp = uploadResponse(json: json) {
                        print("success: \(resp.success), task: \(resp.task_id)")
                        self.task_id = resp.task_id
                    }
                    self.uploadComplete()
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
    
    func downloadIsReady() {
        spinner.stopAnimating()
        dlButton.isHidden = false
        UploadedMessage.text = "All set!"
        UploadedCaption.text = "slam that download button!"
    }
    
    func dowloadComplete() {
        self.performSegue(withIdentifier: "player", sender: self)
    }
    
    func incrementHUD(_ hud: JGProgressHUD, progress previousProgress: Int) {
        let progress = previousProgress + 1
        hud.progress = Float(progress)/100.0
        hud.detailTextLabel.text = "\(progress)% Complete"
        
        if progress == 100 {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                UIView.animate(withDuration: 0.1, animations: {
                    hud.textLabel.text = "Success"
                    hud.detailTextLabel.text = nil
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                
                hud.dismiss(afterDelay: 1.0)
                self.dowloadComplete()

            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
                self.incrementHUD(hud, progress: progress)
            }
        }
    }
}
