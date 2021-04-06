// 
//  HomeData.swift
//
//  Created by Den Jo on 2021/03/28.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI
import AVFoundation
import SoundAnalysis

final class HomeData: NSObject, ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var isAnalyzing = false
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

    private let inputBus      = AVAudioNodeBus(0)
    private var inputFormat   = AVAudioFormat()
    private let analysisQueue = DispatchQueue(label: "analysisQueue")

    private lazy var audioEngine: AVAudioEngine = {
        let audioEngine = AVAudioEngine()
        inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
       
        return audioEngine
    }()
    
    private lazy var streamAnalyzer: SNAudioStreamAnalyzer = {
        let streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
    
        audioEngine.inputNode.installTap(onBus: inputBus, bufferSize: 8192, format: inputFormat) { buffer, time in
            self.analysisQueue.async {
                streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
        
        return streamAnalyzer
    }()
    
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
            DispatchQueue.main.async { self.isAnalyzing = true }
                        
            audioRecorder?.record()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
                self.audioRecorder?.updateMeters()
                
                let threshold: CGFloat = 0.27
                var power = (CGFloat(self.audioRecorder?.peakPower(forChannel: 0) ?? 0) + 80) / 160
                power = max(power - threshold, 0)
                power = 0 < power ? power + threshold : power
                
                self.power = self.power != 0 ? 0 : power
            }
            
            startAudioEngine()
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
        isAnalyzing = false
    }
    
    private func startAudioEngine() {
        do {
            try audioEngine.start()
            
            let request = try SNClassifySoundRequest(mlModel: BabySoundClassifier(configuration: MLModelConfiguration()).model)
            try streamAnalyzer.add(request, withObserver: self)
            
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

// MARK: - SNResults Observing
extension HomeData: SNResultsObserving {
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult, let classification = result.classifications.first else {
            log(.error, "Failed to analyze sounds")
            return
        }
        
        // Determine the time of this result.
        let formattedTime = String(format: "%.2f", result.timeRange.start.seconds)
        log(.info, "Analysis result for audio at time: \(formattedTime)")
        
        let confidence = classification.confidence * 100.0
        let percent = String(format: "%.2f%%", confidence)
        
        // Print the result as Instrument: percentage confidence.
        log(.info, "\(classification.identifier): \(percent) confidence.\n")
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        log(.error, "The the analysis failed: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        log(.error, "The request completed successfully!")
    }
}
