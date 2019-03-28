//
//  files.swift
//  lyrebird
//
//  Created by Robin Diddams on 2/11/19.
//  Copyright © 2019 Robin Diddams. All rights reserved.
//

import Foundation
import CryptoSwift

struct lyreSound {
    let name: String
    let task_id: String
    var originalSoundURL: URL?
    var lyrebirdSoundURL: URL?
    var downloadURL: String?
    var downloadProgress: Double
    var createdAtDate: Date?
}

enum lyrebirdSoundType {
    case recording
    case sound
}

func getSoundURL(id: String, recording: Bool = false) -> URL {
    var postfix = "sound"
    if recording {
        postfix = "recording"
    }
    let currentFileName = "\(id)_\(postfix)" + ".wav"
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = documentsDirectory.appendingPathComponent(currentFileName)
    return url
}

func getAudioRecordPath() -> URL {
    let currentFileName = "lyrebird_recording.wav"
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = documentsDirectory.appendingPathComponent(currentFileName)
    return url
}

func renameAudioRecord(task_id: String) {
    let fileManager = FileManager()
    do {
        try fileManager.moveItem(at: getAudioRecordPath(), to: getSoundURL(id: task_id, recording: true))
    }
    catch let error as NSError {
        print("Error renaming path: \(error)")
    }
}

func deleteAudioRecordings(task_id: String) {
    let recordPath = getSoundURL(id: task_id,recording: true)
    let soundPath = getSoundURL(id: task_id,recording: false)
    let filemanager = FileManager.default
    do {
        try filemanager.removeItem(at: recordPath)
        try filemanager.removeItem(at: soundPath)
    } catch(let err) {
        print("Error while deleteing \(err)")
    }
}

func parseSoundPath(_ path: URL) -> (type: lyrebirdSoundType, task_id: String)? {
    if !path.lastPathComponent.contains(".wav") {
        return nil
    }
    let filename = path.deletingPathExtension().lastPathComponent
    let components = filename.split(separator: "_")
    if components.count != 2 {
        return nil
    }
    if components[0] == "lyrebird" {
        return nil
    }
    switch components[1] {
    case "sound":
        return (lyrebirdSoundType.sound, String(components[0]))
    case "recording":
        return (lyrebirdSoundType.recording, String(components[0]))
    default:
        return nil
    }
    
}

func getSounds() -> [lyreSound] {
    var soundMap = [String : lyreSound]()
    let filemanager = FileManager.default
    let documentsDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    do {
        let paths = try filemanager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
        for path in paths {
            if let sound = parseSoundPath(path) {
                let dat = Array<UInt8>(hex: sound.task_id)
                let name = encode(data: Data(bytes: dat, count: dat.count))
                switch sound.type {
                case .recording:
                    let attrs = try filemanager.attributesOfItem(atPath: path.path)
                    let created_at = attrs[.creationDate] as! Date
                    if soundMap[sound.task_id] == nil {
                        soundMap[sound.task_id] = lyreSound(name: name,
                                                          task_id: sound.task_id,
                                                          originalSoundURL: path,
                                                          lyrebirdSoundURL: nil,
                                                          downloadURL: nil,
                                                          downloadProgress: 0.0,
                                                          createdAtDate: created_at)
                    } else {
                        soundMap[sound.task_id]?.originalSoundURL = path
                        soundMap[sound.task_id]?.createdAtDate = created_at
                    }
                case .sound:
                    if soundMap[sound.task_id] == nil {
                        soundMap[sound.task_id] = lyreSound(name: name,
                                                          task_id: sound.task_id,
                                                          originalSoundURL: nil,
                                                          lyrebirdSoundURL: path,
                                                          downloadURL: nil,
                                                          downloadProgress: 0.0,
                                                          createdAtDate: nil)
                    } else {
                        soundMap[sound.task_id]?.lyrebirdSoundURL = path
                    }
                }
            }
        }
    } catch let e {
        print("error: \(e)")
    }
    var sounds = [lyreSound]()
    for (_, v) in soundMap {
        if v.originalSoundURL != nil {
            sounds.append(v)
        }
    }
    return sounds
}
