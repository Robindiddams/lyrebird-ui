//
//  api.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/12/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import Foundation

struct errorResponse {
    let success: Bool
    let message: String
}

let apiURL = "https://p00plqfrp6.execute-api.us-east-1.amazonaws.com/dev"

extension errorResponse {
    init?(json: [String: Any]) {
        guard let success = json["success"] as? Bool,
            let message = json["message"] as? String
            else {
                return nil
        }
        self.success = success
        self.message = message
    }
}

struct uploadResponse {
    let success: Bool
    let task_id: String
    let URL: String
}

extension uploadResponse {
    init?(json: [String: Any]) {
        guard let success = json["success"] as? Bool,
            let task_id = json["task_id"] as? String,
            let URL = json["upload_url"] as? String
            else {
                return nil
        }
        self.URL = URL
        self.success = success
        self.task_id = task_id
    }
}

struct statusResponse {
    let success: Bool
    let completed: Bool
    var URL: String
}

extension statusResponse {
    init?(json: [String: Any]) {
        guard let success = json["success"] as? Bool,
            let completed = json["completed"] as? Bool
            else {
                return nil
        }
        self.success = success
        self.completed = completed
        self.URL = ""
        if let url = json["download_url"] as? String {
            self.URL = url
        }
    }
}
