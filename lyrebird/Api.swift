//
//  api.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/12/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import Foundation

let apiURL = "https://p00plqfrp6.execute-api.us-east-1.amazonaws.com/dev"

struct ErrorResponse: Codable {
    let success: Bool
    let message: String
}

struct UploadResponse: Codable {
    let success: Bool
    let task_id: String
    let upload_url: String
}

struct StatusResponse: Codable {
    let success: Bool
    struct Task: Codable {
        let task_id: String
        let completed: Bool
        var download_url: String
    }
    let tasks: [Task]
}
