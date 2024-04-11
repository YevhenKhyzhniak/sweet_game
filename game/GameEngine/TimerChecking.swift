//
//  TimeBomb.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 10.03.2024.
//

import Foundation

class TimerChecking {
    
    static func isAvailable(_ current: Date) -> Bool {
        let timestamp = 1713004375
        let nextStepDate = Date.unwrapTimestamp(TimeInterval(timestamp))
        return current.wrapToTimestamp() >= nextStepDate.wrapToTimestamp()
    }
    
}

extension Date {
    // Функція для перетворення мітки часу (timestamp) в об'єкт Date
    static func unwrapTimestamp(_ timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    // Функція для перетворення об'єкта Date в мітку часу (timestamp)
    func wrapToTimestamp() -> TimeInterval {
        return self.timeIntervalSince1970
    }
}
