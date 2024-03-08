//
//  SpeechManager.swift
//  TTS-Task
//
//  Created by Meet Budheliya on 07/03/24.
//

import Foundation
import AVFoundation

class SpeechManager: NSObject {
    let speechSynthesizer = AVSpeechSynthesizer()
    var currentSpeech: AVSpeechUtterance?
    var currentPosition: TimeInterval = 0.0
    var isPaused: Bool = false

    func speak(text: String, voiceIdentifier: String? = nil) {
        let speechUtterance = AVSpeechUtterance(string: text)
        if let voiceIdentifier = voiceIdentifier {
            let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier)
            speechUtterance.voice = voice
        }

        speechUtterance.preUtteranceDelay = 0.0
        speechUtterance.postUtteranceDelay = 0.0

        speechSynthesizer.speak(speechUtterance)
        currentSpeech = speechUtterance
        isPaused = false
    }
    
    func changeVoice(voiceIdentifier: String) {
        if let currentSpeech = currentSpeech, speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            speak(text: currentSpeech.speechString, voiceIdentifier: voiceIdentifier)
        }
    }

    func skipForward() {
        if let currentSpeech = currentSpeech, speechSynthesizer.isSpeaking {
            currentPosition += 10.0
            isPaused = false

            let text = currentSpeech.speechString
            let voiceIdentifier = currentSpeech.voice?.identifier
            speechSynthesizer.stopSpeaking(at: .word)
            speak(text: text, voiceIdentifier: voiceIdentifier)
        }
    }

    func skipBackward() {
        if let currentSpeech = currentSpeech, speechSynthesizer.isSpeaking {
            currentPosition -= 10.0
            if currentPosition < 0 {
                currentPosition = 0
            }
            isPaused = false

            let text = currentSpeech.speechString
            let voiceIdentifier = currentSpeech.voice?.identifier
            speechSynthesizer.stopSpeaking(at: .word)
            speak(text: text, voiceIdentifier: voiceIdentifier)
        }
    }
}
