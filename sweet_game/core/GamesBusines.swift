//
//  GamesBusines.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import Foundation

class GamesBusines {
    
    @Storage(key: "Game.Coins", defaultValue: 1000)
    static var coins: Int
    
    @Storage(key: "Game.Sound", defaultValue: true)
    static var sound: Bool
    
    @Storage(key: "Game.Vibro", defaultValue: true)
    static var vibro: Bool
    
}
