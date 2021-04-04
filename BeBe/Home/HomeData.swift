// 
//  HomeData.swift
//
//  Created by Den Jo on 2021/03/28.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI
import AVFoundation

final class HomeData: NSObject, ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var isRecoding = false
    
    
    // MARK: - Function
    // MARK: Public
    func requestRecord() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.record, mode: .default)
            try session.setActive(true)
            
            session.requestRecordPermission { isGranted in
                guard isGranted else {
                    log(.error, "The record permission isn't granted.")
                    return
                }
                
                self.record()
            }
    
        } catch {
            log(.error, error.localizedDescription)
        }
    }
    
    // MARK: Private
    private func record() {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            log(.error, "Failed to get a file path")
            return
        }
        
        let settings = [AVFormatIDKey           : Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey         : 12000,
                        AVNumberOfChannelsKey   : 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        
        do {
            let recorder = try AVAudioRecorder(url: path.appendingPathComponent("recording.m4a"), settings: settings)
            recorder.delegate = self
            recorder.record()
            
            isRecoding = true
            
        } catch {
            log(.error, error.localizedDescription)
        }
    }
}


// MARK: - AVAudioRecorder Delegate
extension HomeData: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recorder.stop()
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        log(.error, error?.localizedDescription)
        recorder.stop()
    }
}
