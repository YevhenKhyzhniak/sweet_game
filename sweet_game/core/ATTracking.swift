//
//  ATTracking.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 06.03.2024.
//

import Foundation
import AppTrackingTransparency
import AppsFlyerLib
import AdSupport
import OneSignalFramework

final class ATTracking: NSObject {
    
    static let shared = ATTracking()
    
    @Storage(key: "ATTracking.appsFlyerCampaign", defaultValue: "")
    private (set) var appsFlyerCampaign: String
    
    private override init() {
        super.init()
        
        AppsFlyerLib.shared().appsFlyerDevKey = "FSuJH5HaxFdTHjzbkcrgsL" // FSuJH5HaxFdTHjzbkcrgsL
        AppsFlyerLib.shared().appleAppID = "6478985125"
        AppsFlyerLib.shared().delegate = self
        
        self.startAppsFlyer()
    }
    
    func startAppsFlyer() {
        AppsFlyerLib.shared().start()
    }
    
    func openURL(_ url: URL) {
        AppsFlyerLib.shared().handleOpen(url)
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
        return AppsFlyerLib.shared().getAppsFlyerUID()
    }
    
    func initOneSignal(_ options: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.initialize("57c98958-14eb-4bc8-ade2-7558baf0cc8c", withLaunchOptions: options) // b2f7f966-d8cc-11e4-bed1-df8f05be55ba
    }
    
}

extension ATTracking: AppsFlyerLibDelegate {
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        //debugPrint(conversionInfo)
        if let status = conversionInfo["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = conversionInfo["media_source"],
                    let campaign = conversionInfo["campaign"] as? String {
                    
                    self.appsFlyerCampaign = campaign
                    //debugPrint("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            }

        }
    }
    
    func onConversionDataFail(_ error: any Error) {
        debugPrint(error)
    }
    
}

final class OneSignalService {
    
    class func getIdentifier() -> String? {
        return OneSignal.User.pushSubscription.id
    }
    
    class func requestNotifications() async {
        return await withCheckedContinuation {  continuation in
            OneSignal.Notifications.requestPermission({ accepted in
                //debugPrint("User accepted notifications: \(accepted)")
                continuation.resume()
            }, fallbackToSettings: false)
        }
    }
}
