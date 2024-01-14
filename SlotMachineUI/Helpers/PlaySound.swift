//
//  PlaySound.swift
//  SlotMachineUI
//
//  Created by Daniel Washington Ignacio on 12/01/24.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Error: Cound not find and play the sound file!")
        }
    }
}
