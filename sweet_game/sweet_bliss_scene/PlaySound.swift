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
        guard SweetGameLevelBusines.sound else { return }
        let systemSoundID: SystemSoundID = 1118
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    class func run2() {
        guard SweetGameLevelBusines.sound else { return }
        let systemSoundID: SystemSoundID = 1111
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    class func run3() {
        guard SweetGameLevelBusines.sound else { return }
        let systemSoundID: SystemSoundID = 1109
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
}
