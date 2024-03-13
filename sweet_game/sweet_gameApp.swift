//
//  sweet_gameApp.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI

@main
struct sweet_gameApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    ATTracking.shared.openURL(url)
                })
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var context: AppContext?
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        self.context = AppContext(router: MainRouter.init(isPresented: .constant(.showMain)))
        ATTracking.shared.initOneSignal(launchOptions)
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    static func disableOrientationLock() {
    }
}
