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

final class ATTracking: NSObject {
    
    static let shared = ATTracking()
    
    @Storage(key: "ATTracking.appsFlyerCampaign", defaultValue: "hdjsk_jcksdl_jckds")
    private (set) var appsFlyerCampaign: String
    
    private override init() {
        super.init()
        
        AppsFlyerLib.shared().appsFlyerDevKey = "pMkdsDi4tKZp8nFHGaLPy6"
        AppsFlyerLib.shared().appleAppID = "6469056521"
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
        let _ = await ATTrackingManager.requestTrackingAuthorization()
        try await Task.sleep(nanoseconds: duration)
    }
    
    func getTrackingIdentifier() -> String? {
        let emptyTemplate = "00000000-0000-0000-0000-000000000000"
        let id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        return emptyTemplate == id ? nil : id
    }
    
}

extension ATTracking: AppsFlyerLibDelegate {
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        if let status = conversionInfo["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = conversionInfo["media_source"],
                    let campaign = conversionInfo["campaign"] as? String {
                    
                    self.appsFlyerCampaign = campaign
                    debugPrint("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            }

        }
    }
    
    func onConversionDataFail(_ error: any Error) {
        debugPrint(error)
    }
    
}

final class OneSignal {
    
    class func getIdentifier() -> String? {
        return "688768"
    }
    
    class func requestNotifications() {
        
    }
}

//class WorkWithSub {
//    
//    static func saveNaming(str: String){ // hdjsk_jcksdl_jckds
//        let arr = str.components(separatedBy: "_")
//        var finalStr = ""
//        for i in 0..<arr.count{
//            if i == 0{
//                finalStr.append("?sub\(i+1)=\(arr[i])")
//            } else {
//                finalStr.append("&sub\(i+1)=\(arr[i])")
//            }
//        }
//        if UserDefaults.standard.object(forKey: "firstEntry") == nil {
//            UserDefaults.standard.set(true, forKey: "firstEntry")
//            UserDefaults.standard.setValue(finalStr, forKey: "savedSub")
//        }
//    }
//}
