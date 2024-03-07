//
//  AppStateLogic.swift
//
//
//  Created by Yevhen Khyzhniak on 30.10.2023.
//

import Foundation
import Combine

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
        guard let initialURL = URL(string: self.initialURLConstant) else {
            self.state.send(.game)
            return
        }
        
        Task {
            // 1 step
            try await ATTracking.shared.requestTracking(2.0)
            // 2 step
            OneSignal.requestNotifications()
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            // 3 step
            let trackingID = ATTracking.shared.getTrackingIdentifier() ?? "hdjsk_jcksdl_jckds"
            let oneSignalID = OneSignal.getIdentifier()
            let appsFlyerID = ATTracking.shared.appsFlyerCampaign
            
            let enrichedUrl = await self.makeEnrichedURL(initialURL, appleTrackingID: trackingID, oneSignalID: oneSignalID, appsFlyerID: appsFlyerID)
            
            var result: AppState
            
            do {
                // 4 step
                let redirectURL = try await self.redirect.getRedirectionUrl(URLRequest(url: enrichedUrl))
                
                debugPrint(enrichedUrl, redirectURL)
                
                result = enrichedUrl != redirectURL ? .web(redirectURL) : .game
            } catch {
                result = .game
            }
            
            self.appState = result
            await MainActor.run {
                self.state.send(self.appState)
            }
            
        }
    }
    
    private func makeEnrichedURL(
        _ initial: URL,
        appleTrackingID: String?,
        oneSignalID: String?,
        appsFlyerID: String
    ) async -> URL {
        
        var result: URL = initial
        
        let endpoint = self.makeEndpointFromAppsFlyer(appsFlyerID)
        
        return result
            .addEndpoint(endpoint: endpoint)
            .addParams(params: ["sub7": appleTrackingID])
            .addParams(params: ["sub15": oneSignalID])
    }
    
    private func makeEndpointFromAppsFlyer(_ id: String) -> String {
        let arr = id.split(separator: "_")
        let finalStr = arr.enumerated().map { (index, element) in
            return "\(index == 0 ? "?" : "&")sub\(index + 1)=\(element)"
        }.joined()
        return finalStr
    }
    
}
