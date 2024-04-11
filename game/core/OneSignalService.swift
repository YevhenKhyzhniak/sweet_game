//
//  ATTracking.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 06.03.2024.
//

import Foundation
import Firebase
import OneSignalFramework

final class OneSignalService: NSObject {
    
    static let shared = OneSignalService()
    
    private override init() {
        super.init()
        
        FirebaseApp.configure()
    }
    
    func initOneSignal(_ options: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.initialize("d4f1487-dea1-4327-817a-641580adaed1", withLaunchOptions: options)
    }
    
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
