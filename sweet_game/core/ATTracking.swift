//
//  ATTracking.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 06.03.2024.
//

import Foundation
import AppTrackingTransparency
import AdSupport
import UIKit

final class ATTracking: NSObject {
    
    static let shared = ATTracking()
    
    @Storage(key: "ATTracking.appsFlyerCampaign", defaultValue: "")
    private (set) var appsFlyerCampaign: String
    
    private override init() {
        super.init()
        self.startAppsFlyer()
    }
    
    func startAppsFlyer() {
    }
    
    func openURL(_ url: URL) {
    }
    
    func requestTracking(_ timeout: Double = 2.0) async throws {
        let duration = UInt64(timeout * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
        let _ = await ATTrackingManager.requestTrackingAuthorization()
    }
    
    func getTrackingIdentifier() -> String? {
        let emptyTemplate = "00000000-0000-0000-0000-000000000000"
        let id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        return emptyTemplate == id ? nil : id
    }
    
    func getAppsFlyerID() -> String {
        return ""
    }
    
    func initOneSignal(_ options: [UIApplication.LaunchOptionsKey: Any]?) {
        
    }
    
}

final class OneSignalService {
    
    class func getIdentifier() -> String? {
        return nil//return OneSignal.User.pushSubscription.id
    }
    
    class func requestNotifications() async {
    }
}
