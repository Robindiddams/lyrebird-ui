//
//  files.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/11/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import Foundation

func getSoundPath(name: String) -> URL {
    let currentFileName = "\(name)-sound" + ".wav"
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

func deleteAudioRecording() {
    let path = getAudioRecordPath()
    let filemanager = FileManager.default
    do {
        try filemanager.removeItem(at: path)
    }catch(let err){
        print("Error while deleteing \(err)")
    }
}
