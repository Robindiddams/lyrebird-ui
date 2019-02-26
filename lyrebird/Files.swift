//
//  files.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/11/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import Foundation

func getSoundURL(name: String, recording: Bool = false) -> URL {
    var postfix = "sound"
    if recording {
        postfix = "recording"
    }
    let currentFileName = "\(name)-\(postfix)" + ".wav"
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = documentsDirectory.appendingPathComponent(currentFileName)
    return url
}

func getAudioRecordPath() -> URL {
    let currentFileName = "lyrebird-recording.wav"
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = documentsDirectory.appendingPathComponent(currentFileName)
    return url
}

func renameAudioRecord(task_id: String) {
    let fileManager = FileManager()
    do {
        try fileManager.moveItem(at: getAudioRecordPath(), to: getSoundURL(name: task_id, recording: true))
    }
    catch let error as NSError {
        print("Error renaming path: \(error)")
    }
}

func deleteAudioRecordings(task_id: String) {
    let recordPath = getSoundURL(name: task_id,recording: true)
    let soundPath = getSoundURL(name: task_id,recording: false)
    let filemanager = FileManager.default
    do {
        try filemanager.removeItem(at: recordPath)
        try filemanager.removeItem(at: soundPath)
    }catch(let err){
        print("Error while deleteing \(err)")
    }
}
