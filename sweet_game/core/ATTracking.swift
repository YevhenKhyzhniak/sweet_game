//
//  ATTracking.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 06.03.2024.
//

import Foundation
import AppTrackingTransparency

final class ATTracking {
    
    class func requestTracking(_ timeout: Double = 2.0) {
        Task {
            let duration = UInt64(timeout * 1_000_000_000)
            try await Task.sleep(nanoseconds: duration)
            let _ = await ATTrackingManager.requestTrackingAuthorization()
        }
    }
    
}
