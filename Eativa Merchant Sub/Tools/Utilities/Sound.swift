//
//  Sound.swift
//  Eativa Merchant Sub
//
//  Created by Frederic Orlando on 06/01/20.
//  Copyright © 2020 Frederic Orlando. All rights reserved.
//

import Foundation
import AVFoundation

class NotificationSound {
    static var audioPlayer : AVAudioPlayer?
    
    static func play() {
        let path = Bundle.main.path(forResource: "soundEffect.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed")
        }
    }
}
