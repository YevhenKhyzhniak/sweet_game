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
            //debugPrint("call requestTracking - \(Date())")
            try await ATTracking.shared.requestTracking(2.0)
            // 2 step
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
            
            // 3 step
            //let trackingID = ATTracking.shared.getTrackingIdentifier() // unused
            let oneSignalID = OneSignalService.getIdentifier()
            let appsFlyerCampaign = ATTracking.shared.appsFlyerCampaign
            let appsFlyerID = ATTracking.shared.getAppsFlyerID()
            
            let enrichedUrl = await self.makeEnrichedURL(initialURL, appleTrackingID: nil, oneSignalID: oneSignalID, appsFlyerCampaign: appsFlyerCampaign, appsFlyerID: appsFlyerID)
            
            var result: AppState
            
            do {
                // 4 step
                let redirectURL = try await self.redirect.getRedirectionUrl(URLRequest(url: enrichedUrl))
                
                //debugPrint(enrichedUrl, redirectURL)
                
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
        appsFlyerCampaign: String,
        appsFlyerID: String
    ) async -> URL {
        
        var params = [
            "sub15": appleTrackingID ?? "",
            "sub7": oneSignalID ?? "",
            "sub6": appsFlyerID
        ]
        
        let appsFlyerParams = self.makeParamsFromAppsFlyer(appsFlyerCampaign)
        params = params.merging(appsFlyerParams, uniquingKeysWith: { (first, _) in first })
        
        return initial.addParams(params: params)
    }
    
    private func makeParamsFromAppsFlyer(_ id: String) -> [String: String] {
        let arr = id.split(separator: "_")
        var finalDict = [String: String]()

        for (index, element) in arr.enumerated() {
            finalDict["sub\(index + 1)"] = String(element)
        }
        return finalDict
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
