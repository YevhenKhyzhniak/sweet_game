//
//  sweet_gameApp.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI
import OneSignalFramework

@main
struct sweet_gameApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
        AppDelegate.orientationLock = UIInterfaceOrientationMask.landscape
        
        if #available(iOS 16.0, *) {

            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene

            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))

        }
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    static func enableOrientationLock() {
        AppDelegate.orientationLock = UIInterfaceOrientationMask.all
        
        if #available(iOS 16.0, *) {

            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene

            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))

        }
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
