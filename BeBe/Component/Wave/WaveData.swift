// 
//  WaveData.swift
//
//  Created by Den Jo on 2021/04/14.
//  Copyright © nilotic. All rights reserved.
//

import SwiftUI

final class WaveData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var waves = [Wave]()
    
    // MARK: Private
    private let frequency: CGFloat        = 1.5
    private var amplitude: CGFloat        = 0
    private let density: CGFloat          = 1
    private let primaryLineWidth: CGFloat = 1.5
    private let count: UInt               = 6
    
    private var time: CGFloat     = 0
    private let timeUnit: CGFloat = -0.15
    
    private var waveTimer: Timer? = nil
    private var powers = [CGFloat]()
    
    
    // MARK: - Function
    // MARK: Public
    func update(power: CGFloat) {
        powers.append(power)
    }
    
    func updateTimer(isRecording: Bool) {
        switch isRecording {
        case true:      setTimer()
        case false:     waveTimer?.invalidate()
        }
    }
    
    // MARK: Private
    private func setTimer() {
        waveTimer = Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) { timer in
            self.time += self.timeUnit
            
            if let first = self.powers.first {
                self.amplitude = self.amplitude < first ? self.amplitude + 0.038 : self.amplitude - 0.038
                
                if abs(self.amplitude - first) < 0.1 {
                    self.powers.removeFirst()
                }
            }
            
            var waves = [Wave]()
            for i in 0..<self.count {
                let wave = Wave(index: i, count: self.count, primaryLineWidth: self.primaryLineWidth, amplitude: self.amplitude, frequency: self.frequency, density: self.density, time: self.time)
                waves.append(wave)
            }
            
            self.waves = waves
        }
    }
}
