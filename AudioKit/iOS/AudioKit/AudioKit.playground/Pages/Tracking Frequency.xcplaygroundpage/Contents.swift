//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## Tracking Frequency
//: ### Tracking frequency is just as easy as tracking amplitude, and even includes amplitude, but it is more CPU intensive, so if you just need amplitude, use the amplitude tracker.

//: Standard imports and AudioKit setup:
import XCPlayground
import AudioKit

let audiokit = AKManager.sharedInstance

//: Let's set up the volume to be changing in the shape of a sine wave
let volume = sineWave(frequency:0.2).scaledTo(minimum: 0.3, maximum: 1)

//: And let's make the frequency also be a sineWave
let minimum = Double(200)
let maximum = Double(800)
let frequency = sineWave(frequency: 0.5).scaledTo(minimum: minimum, maximum: maximum)

//: So our oscillator will move around randomly in frequency and have a smoothly varying amplitude
let oscillator = sineWave(frequency: frequency, amplitude: volume)

//: Connect up the the nodes
let oscillatorNode = AKOperationGenerator(operation: oscillator)
let tracker = AKFrequencyTracker(oscillatorNode, minimumFrequency: minimum, maximumFrequency: maximum)


//: The frequency tracker passes its input to the output, so we can insert into the signal chain at the bottom
audiokit.audioOutput = tracker
audiokit.start()

//: And here's where we monitor the results of tracking the amplitude.
let updater = AKPlaygroundLoop(every: 0.1) {
    let amp = tracker.amplitude
    let freq = tracker.frequency

}

//: This keeps the playground running so that audio can play for a long time
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true


//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
