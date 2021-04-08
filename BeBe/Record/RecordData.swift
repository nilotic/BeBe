// 
//  RecordData.swift
//
//  Created by Den Jo on 2021/04/07.
//  Copyright © nilotic. All rights reserved.
//

import Foundation

import SwiftUI
import AVFoundation
import SoundAnalysis

final class RecordData: NSObject, ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var isRecording = false
    @Published var power: CGFloat = 0
    @Published var soundType: BabySoundType = .none

    @Published var isPermissionAlertPresented = false
    @Published var isPickerPresented = false
    
    @Published private(set) var alert: Alert? = nil {
        didSet {
            guard alert != nil else { return}
            isPermissionAlertPresented = true
        }
    }
    
    // MARK: Private
    private var timer: Timer? = nil
    
    private lazy var audioRecorder: AVAudioRecorder? = {
        guard let url = fileURL else {
            log(.error, "Failed to get a file url.")
            return nil
        }
        
        var settings: [String: Any] {
            [AVFormatIDKey           : kAudioFormatMPEG4AAC_HE,
             AVSampleRateKey         : 44100,
             AVNumberOfChannelsKey   : 1,
             AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        }
        
        let audioRecorder = try? AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.delegate = self
        return audioRecorder
    }()
    
    private var fileURL: URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return path.appendingPathComponent("recording.m4a")
    }
    
    
    // MARK: - Function
    // MARK: Public
    func startRecord() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            guard record() else {
                alert = Alert(title: Text("Error"), message: Text("Failed to analyze a voice."), dismissButton: .default(Text("OK")))
                return
            }
            
        case .undetermined:
            AVCaptureDevice.requestAccess(for: .audio) { isGranted in
                guard isGranted else {
                    self.alert = Alert(title: Text("Error"), message: Text("Failed to analyze a voice."), dismissButton: .default(Text("OK")))
                    return
                }
                
                guard self.record() else {
                    self.alert = Alert(title: Text("Error"), message: Text("Failed to analyze a voice."), dismissButton: .default(Text("OK")))
                    return
                }
            }
            
        case .denied:
            var primaryButton: Alert.Button {
                Alert.Button.default(Text("Settings")) {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
            }
            
            alert = Alert(title: Text("Error"), message: Text("Turn on microphone to allow the app to analyze a voice."), primaryButton: primaryButton, secondaryButton: .cancel())
            
        default:
            break
        }
    }
    
    func stopRecord() {
        audioRecorder?.stop()
        timer?.invalidate()

        isRecording = false
        power = 0
    }
    
    func save() {
        isPickerPresented = false
        
        var filePath: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"

            let category = soundType.description.lowercased()
            return "\(category)/\(category)_\(dateFormatter.string(from: Date())).m4a"
        }
        
        // Load a file
        guard let recordURL = fileURL, let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(filePath) else {
            log(.error, "Failed to get a file url.")
            return
        }
        
        do {
            try FileManager.default.moveItem(at: recordURL, to: url)
         
        } catch {
            log(.error, error.localizedDescription)
        }
    }
    
    // MARK: Private
    private func record() -> Bool {
        soundType = .none
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
            DispatchQueue.main.async { self.isRecording = true }
            
            audioRecorder?.record()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                self.audioRecorder?.updateMeters()
                
                var power = (CGFloat(self.audioRecorder?.peakPower(forChannel: 0) ?? 0) + 80) / 160
                power = max(power, 0)
                power = 0 < power ? power : power
                
                self.power = self.power != 0 ? 0 : power
            }
            
            return true
            
        } catch {
            log(.error, error.localizedDescription)
            return false
        }
    }
}


// MARK: - AVAudioRecorder Delegate
extension RecordData: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        withAnimation {
            isPickerPresented = true
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        log(.error, error?.localizedDescription)
        recorder.stop()
    }
}
