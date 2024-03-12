//
//  PlaySound.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 02.03.2024.
//

import Foundation
import AVFoundation

class PlaySound {
    
    class func run() {
        guard GamesBusines.sound else { return }
        let systemSoundID: SystemSoundID = 1118
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    class func run2() {
        guard GamesBusines.sound else { return }
        let systemSoundID: SystemSoundID = 1160
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    class func run3() {
        guard GamesBusines.sound else { return }
        let systemSoundID: SystemSoundID = 1109
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    class func run4() {
        guard GamesBusines.sound else { return }
        let systemSoundID: SystemSoundID = 1321
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
}
