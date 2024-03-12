//
//  GamesBusines.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import Foundation

class GamesBusines {
    
    @Storage(key: "SweetBlissGameLevels", defaultValue: [])
    static var levels: [SweetBlissGameLevel]
    
    @Storage(key: "TigerAdventure", defaultValue: [])
    static var tigersAdventure: [Tiger]
    
    @Storage(key: "TigerCloud", defaultValue: [])
    static var tigersCloud: [Tiger]
    
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
    
    static func unlockNextAdventureTiger(current data: Tiger) -> [Tiger] {
        var copy = Self.tigersAdventure
        if let index = copy.firstIndex(where: {$0.price == data.price}) {
            copy[index].unlocked = .unlocked
        }
        return copy
    }
    
    static func changeSelectedAdventureTiger(current data: Tiger) -> [Tiger] {
        var copy = Self.tigersAdventure
        if let selectedIndex = copy.firstIndex(where: {$0.isSelected == true}) {
            copy[selectedIndex].isSelected = false
        }
        if let index = Self.tigersAdventure.firstIndex(where: {$0.price == data.price}) {
            guard copy.count > index + 1 else { return copy }
            copy[index].isSelected = true
        }
        return copy
    }
    
}
