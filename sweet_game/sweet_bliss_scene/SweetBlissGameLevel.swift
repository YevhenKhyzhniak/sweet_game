//
//  SweetBlissGameLevel.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import Foundation

struct SweetBlissGameLevel: Codable, Hashable {
    
    static func == (lhs: SweetBlissGameLevel, rhs: SweetBlissGameLevel) -> Bool {
        return lhs.level == rhs.level
    }
    
    init(level: Int) {
        self.level = level
        self.unlocked = level == 1 ? .finished : .locked
    }
    
    let level: Int
    var requiredItems: [Item] = []
    
    var unlocked: State
    
    
    var levelString: String {
        return String(format: "%d", level)
    }
    
    
    enum Item: Codable, Hashable {
        case candy(Int)
        case marshmallow(Int)
        case сhupachups(Int)
    }
    
    enum State: Codable, Hashable {
        case locked
        case unlocked
        case finished
    }
    
}
