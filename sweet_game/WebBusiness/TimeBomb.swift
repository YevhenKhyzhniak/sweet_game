//
//  TimeBomb.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 10.03.2024.
//

import Foundation

class TimeBomb {
    
    static func isAvailableToMakeNextStep(_ current: Date) -> Bool {
        let timestamp = 1713004375 // Sat Apr 13 2024 10:32:55 GMT+0000
        let nextStepDate = Date.fromTimestamp(TimeInterval(timestamp))
        return current.toTimestamp() >= nextStepDate.toTimestamp()
    }
    
}

extension Date {
    // Функція для перетворення мітки часу (timestamp) в об'єкт Date
    static func fromTimestamp(_ timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    // Функція для перетворення об'єкта Date в мітку часу (timestamp)
    func toTimestamp() -> TimeInterval {
        return self.timeIntervalSince1970
    }
}
