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
    
    @Storage(key: "Game.Coins", defaultValue: 1000)
    static var coins: Int
    
    @Storage(key: "Game.Sound", defaultValue: true)
    static var sound: Bool
    
    @Storage(key: "Game.Vibro", defaultValue: true)
    static var vibro: Bool
    
    
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
