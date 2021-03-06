// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Karplus-Strong plucked string instrument.
/// 
public class PluckedString: Node, AudioUnitContainer, Toggleable {

    /// Unique four-letter identifier "pluk"
    public static let ComponentDescription = AudioComponentDescription(generator: "pluk")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = InternalAU

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for frequency
    public static let frequencyDef = NodeParameterDef(
        identifier: "frequency",
        name: "Variable frequency. Values less than the initial frequency are doubled until greater than that.",
        address: akGetParameterAddress("PluckedStringParameterFrequency"),
        range: 0 ... 22_000,
        unit: .hertz,
        flags: .default)

    /// Variable frequency. Values less than the initial frequency are doubled until greater than that.
    @Parameter public var frequency: AUValue

    /// Specification details for amplitude
    public static let amplitudeDef = NodeParameterDef(
        identifier: "amplitude",
        name: "Amplitude",
        address: akGetParameterAddress("PluckedStringParameterAmplitude"),
        range: 0 ... 1,
        unit: .generic,
        flags: .default)

    /// Amplitude
    @Parameter public var amplitude: AUValue

    // MARK: - Audio Unit

    /// Internal Audio Unit for PluckedString
    public class InternalAU: AudioUnitBase {
        /// Get an array of the parameter definitions
        /// - Returns: Array of parameter definitions
        public override func getParameterDefs() -> [NodeParameterDef] {
            [PluckedString.frequencyDef,
             PluckedString.amplitudeDef]
        }

        /// Create the DSP Refence for this node
        /// - Returns: DSP Reference
        public override func createDSP() -> DSPRef {
            akCreateDSP("PluckedStringDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this pluck node
    ///
    /// - Parameters:
    ///   - frequency: Variable frequency. Values less than the initial frequency are doubled until greater than that.
    ///   - amplitude: Amplitude
    ///   - lowestFrequency: This frequency is used to allocate all the buffers needed for the delay. This should be the lowest frequency you plan on using.
    ///
    public init(
        frequency: AUValue = 110,
        amplitude: AUValue = 0.5,
        lowestFrequency: AUValue = 110
    ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.frequency = frequency
            self.amplitude = amplitude
        }
    }

    // MARK: - Control

    /// Trigger the sound with current parameters
    ///
    open func trigger() {
        internalAU?.start()
        internalAU?.trigger()
    }

    /// Trigger the sound with a set of parameters
    ///
    /// - Parameters:
    ///   - frequency: Frequency in Hz
    ///   - amplitude: Volume
    ///
    open func trigger(frequency: AUValue, amplitude: AUValue = 1) {
        self.frequency = frequency
        self.amplitude = amplitude
        internalAU?.start()
        internalAU?.triggerFrequency(frequency, amplitude: amplitude)
    }

}
