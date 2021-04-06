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
    @Published var isPermissionAlertPresented = false
    @Published var power: CGFloat = 0
    
    @Published private(set) var alert: Alert? = nil {
        didSet {
            guard alert != nil else { return}
            isPermissionAlertPresented = true
        }
    }
    
    // MARK: Private
    private var timer: Timer? = nil
    
    private lazy var audioRecorder: AVAudioRecorder? = {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            log(.error, "Failed to get a file path")
            return nil
        }
        
        var settings: [String: Any] {
            [AVFormatIDKey           : kAudioFormatAppleLossless,
             AVSampleRateKey         : 44100,
             AVNumberOfChannelsKey   : 1,
             AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        }
        
        let audioRecorder = try? AVAudioRecorder(url: path.appendingPathComponent("recording.m4a"), settings: settings)
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.delegate = self
        return audioRecorder
    }()
  
    
    // MARK: - Function
    // MARK: Public
    func requestAnalyze() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            guard startRecord() else {
                alert = Alert(title: Text("Error"), message: Text("Failed to analyze a voice."), dismissButton: .default(Text("OK")))
                return
            }
            
        case .undetermined:
            AVCaptureDevice.requestAccess(for: .audio) { isGranted in
                guard isGranted else {
                    log(.error, "Failed to get the audio permission.")
                    return
                }
                
                guard self.startRecord() else {
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
    
    func stopAnalyze() {
        stopRecord()
    }
    
    
    // MARK: Private
    private func startRecord() -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
            DispatchQueue.main.async { self.isRecoding = true }
                        
            audioRecorder?.record()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                self.audioRecorder?.updateMeters()
                
                let power = min((abs(CGFloat(self.audioRecorder?.averagePower(forChannel: 0) ?? 0)) / 160) * 2, 1)
                self.power = self.power != 0 ? 0 : power
            }
            
            return true
            
        } catch {
            log(.error, error.localizedDescription)
            return false
        }
    }
                                     
    private func stopRecord() {
        timer?.invalidate()
        audioRecorder?.stop()
        power = 0
        isRecoding = false
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
