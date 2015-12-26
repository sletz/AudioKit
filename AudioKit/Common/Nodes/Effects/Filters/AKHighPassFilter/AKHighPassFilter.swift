//
//  AKHighPassFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/// AudioKit version of Apple's HighPassFilter Audio Unit
///
/// - parameter input: Input node to process
/// - parameter cutoffFrequency: Cutoff Frequency (Hz) ranges from 10 to 22050 (Default: 6900)
/// - parameter resonance: Resonance (dB) ranges from -20 to 40 (Default: 0)
///
public struct AKHighPassFilter: AKNode {
    
    private let cd = AudioComponentDescription(
        componentType: kAudioUnitType_Effect,
        componentSubType: kAudioUnitSubType_HighPassFilter,
        componentManufacturer: kAudioUnitManufacturer_Apple,
        componentFlags: 0,
        componentFlagsMask: 0)
    
    internal var internalEffect = AVAudioUnitEffect()
    internal var internalAU = AudioUnit()
    public var avAudioNode: AVAudioNode
    
    /// Cutoff Frequency (Hz) ranges from 10 to 22050 (Default: 6900)
    public var cutoffFrequency: Double = 6900 {
        didSet {
            if cutoffFrequency < 10 {
                cutoffFrequency = 10
            }
            if cutoffFrequency > 22050 {
                cutoffFrequency = 22050
            }
            AudioUnitSetParameter(
                internalAU,
                kHipassParam_CutoffFrequency,
                kAudioUnitScope_Global, 0,
                Float(cutoffFrequency), 0)
        }
    }
    
    /// Resonance (dB) ranges from -20 to 40 (Default: 0)
    public var resonance: Double = 0 {
        didSet {
            if resonance < -20 {
                resonance = -20
            }
            if resonance > 40 {
                resonance = 40
            }
            AudioUnitSetParameter(
                internalAU,
                kHipassParam_Resonance,
                kAudioUnitScope_Global, 0,
                Float(resonance), 0)
        }
    }
    
    /// Initialize the high pass filter node
    ///
    /// - parameter input: Input node to process
    /// - parameter cutoffFrequency: Cutoff Frequency (Hz) ranges from 10 to 22050 (Default: 6900)
    /// - parameter resonance: Resonance (dB) ranges from -20 to 40 (Default: 0)
    ///
    public init(
        _ input: AKNode,
        cutoffFrequency: Double = 6900,
        resonance: Double = 0) {
            
            self.cutoffFrequency = cutoffFrequency
            self.resonance = resonance
            
            internalEffect = AVAudioUnitEffect(audioComponentDescription: cd)
            self.avAudioNode = internalEffect
            AKManager.sharedInstance.engine.attachNode(self.avAudioNode)
            AKManager.sharedInstance.engine.connect(input.avAudioNode, to: self.avAudioNode, format: AKManager.format)
            internalAU = internalEffect.audioUnit
            
            AudioUnitSetParameter(internalAU, kHipassParam_CutoffFrequency, kAudioUnitScope_Global, 0, Float(cutoffFrequency), 0)
            AudioUnitSetParameter(internalAU, kHipassParam_Resonance, kAudioUnitScope_Global, 0, Float(resonance), 0)
    }
}
