//
//  SweetBlissGameLevelBusines.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import Foundation

class SweetGameLevelBusines {
    
    @Storage(key: "SweetBlissGameLevels", defaultValue: [])
    static var levels: [SweetBlissGameLevel]
    
    @Storage(key: "SweetGame.Candies", defaultValue: 1000)
    static var candies: Int
    
    
    @Storage(key: "SweetBlissGameLevelsHeartRate", defaultValue: 75.0)
    static var heartRate: Double
    
    static func unlockNextLevel(current data: SweetBlissGameLevel) {
        if let index = Self.levels.firstIndex(where: {$0.level == data.level}) {
            guard Self.levels.count > index + 1 else { return }
            Self.levels[index].unlocked = .finished
            Self.levels[index + 1].unlocked = .unlocked
        }
    }
    
}
