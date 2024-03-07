//
//  ATTracking.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 06.03.2024.
//

import Foundation
import AppTrackingTransparency
import AppsFlyerLib

final class ATTracking: NSObject {
    
    static let shared = ATTracking()
    
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
        try await Task.sleep(nanoseconds: duration)
        let _ = await ATTrackingManager.requestTrackingAuthorization()
    }
    
}

extension ATTracking: AppsFlyerLibDelegate {
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        if let status = conversionInfo["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = conversionInfo["media_source"],
                    let campaign = conversionInfo["campaign"] as? String {
                    
                    WorkWithSub.saveNaming(str: campaign)
                    debugPrint("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            }

        }
    }
    
    func onConversionDataFail(_ error: any Error) {
        debugPrint(error)
    }
    
}

class WorkWithSub {
    
    static func saveNaming(str: String){
        let arr = str.components(separatedBy: "_")
        var finalStr = ""
        for i in 0..<arr.count{
            if i == 0{
                finalStr.append("?sub\(i+1)=\(arr[i])")
            } else {
                finalStr.append("&sub\(i+1)=\(arr[i])")
            }
        }
        if UserDefaults.standard.object(forKey: "firstEntry") == nil {
            UserDefaults.standard.set(true, forKey: "firstEntry")
            UserDefaults.standard.setValue(finalStr, forKey: "savedSub")
        }
    }
}
