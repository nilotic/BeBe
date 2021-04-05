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
    
    @Published private(set) var alert: Alert? = nil {
        didSet {
            guard alert != nil else { return}
            isPermissionAlertPresented = true
        }
    }
    
    // MARK: Private
    private let captureSession = AVCaptureSession()
    private let audioOutput = AVCaptureAudioDataOutput()
    private let captureQueue = DispatchQueue(label: "captureQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private let sessionQueue = DispatchQueue(label: "sessionQueue", attributes: [], autoreleaseFrequency: .workItem)
    
    
    // MARK: - Function
    // MARK: Public
    func requestAnalyze() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            guard analyze() else {
                alert = Alert(title: Text("Error"), message: Text("Failed to analyze a voice."), dismissButton: .default(Text("OK")))
                return
            }
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { isGranted in
                guard isGranted else {
                    log(.error, "Failed to get the audio permission.")
                    return
                }
                
                guard self.analyze() else {
                    self.alert = Alert(title: Text("Error"), message: Text("Failed to analyze a voice."), dismissButton: .default(Text("OK")))
                    return
                }
            }
        
        case .denied, .restricted:
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
        
        /*
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
        }*/
    }
    
    // MARK: Private
    private func analyze() -> Bool {
        guard setCaptureSession() else { return false }
        
        
        
        /*
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
        }*/
        
        return true
    }
    
    private func setCaptureSession() -> Bool {
        captureSession.beginConfiguration()
        
        guard captureSession.canAddOutput(audioOutput) else {
            log(.error, "Failed to add the audio output")
            return false
        }
        
        guard let device = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified) else {
            log(.error, "Failed to get a microphone.")
            return false
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            guard captureSession.canAddInput(input) else {
                log(.error, "Failed to add a input.")
                return false
            }
            
            captureSession.commitConfiguration()
            
        } catch {
            log(.error, error.localizedDescription)
            return false
        }
        
        return true
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
