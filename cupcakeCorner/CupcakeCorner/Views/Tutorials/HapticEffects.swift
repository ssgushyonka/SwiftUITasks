import SwiftUI

struct HapticEffects : View {
    @State private var counter = 0
    
    var body : some View {
        Button("Tap Count: \(counter)") {
            counter += 1
        }
        .sensoryFeedback(.increase, trigger: counter)
        // `.increase` is best for a counter
        // others are `.success`, `.warning`, `.error`, `.start`, and `.stop`. There are more.
        // Blind users may rely on these to convey information
        
    }
}

struct HapticEffects2 : View {
    @State private var counter = 0
    
    var body : some View {
        Button("Tap Count: \(counter)") {
            counter += 1
        }
        //`.impact` variant 1
        //  specify how Flexible your object is,
        //      and how strong the effect should be
        .sensoryFeedback(
            .impact(flexibility: .soft, intensity: 0.5), //Middling collision btw 2 soft objects.
            trigger: counter
        )
    }
}

struct HapticEffects3 : View {
    @State private var counter = 0
    
    var body : some View {
        Button("Tap Count: \(counter)") {
            counter += 1
        }
        //`.impact` variant 2
        //  specify a Weight and an Intensity
        .sensoryFeedback(
            .impact(weight: .heavy, intensity: 1), //collision btw 2 heavy objects.
            trigger: counter
        )
    }
}

// CORE HAPTICS
//  A more advanced framework.
//  Highly customizable haptics by combining
//      - taps
//      - continuous vibrations
//      - parameter curves
//      - ...

import CoreHaptics

struct HapticEffects4 : View {
    @State private var engine : CHHapticEngine?
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error creating CoreHaptics engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func evenMoreComplexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    var body : some View {
        VStack {
            Button("Tap me", action: complexSuccess)
                .onAppear(perform: prepareHaptics)
        }
    }
}

#Preview {
    HapticEffects()
}
