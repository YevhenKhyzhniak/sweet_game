//
//  LogicWebView.swift
//
//
//  Created by Yevhen Khyzhniak on 30.10.2023.
//

import Foundation
import WebKit
import Combine
import AdSupport

public enum LogicWebViewState {
    case inProcess
    case playGame(URLRequest)
}

public class LogicWebView {
    
    public let state: PassthroughSubject<LogicWebViewState, Never> = .init()
    
    public init(appID: String, initialUrlConst: String) {
        self.initialUrlConst = initialUrlConst
        self.appID = appID
    }
    
    private let initialUrlConst: String
    private let appID: String
    
    @Storage(key: "LogicWebView.DynamicURLKey", defaultValue: nil)
    var dynamicURL: URL?
    
    
    public func onStart() {
        self.state.send(.inProcess)
        Task {
            try await ATTracking.shared.requestTracking()
            try await Task.sleep(nanoseconds: 4_000_000_000) // хуйня, треба ловить в Adjust коли прилетіли дані
            let url = self.onCreateURL()
            debugPrint(url)
            await MainActor.run {
                self.state.send(.playGame(.init(url: url)))
            }
        }
    }
    
    private func onCreateURL() -> URL {
        if let dynamicURL { return dynamicURL }
        let initialURL = URL(string: self.initialUrlConst)!
        
        //https://babble-set.space/32c2da77cdca?stream_hash={aj_campaign}&sid1={aj_campaign}&sid2={aj_creative}&sid3={aj_adgroup}&app_sid1={idfa}&app_sid2={app_id}&app_sid3={aj_adid}
        let srmHash = "32c2da77cdca"
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        self.dynamicURL = initialURL
        
        return initialURL
            .addEndpoint(endpoint: srmHash)
            .addParams(params: ["stream_hash": LogicAdjust.campaign])
            .addParams(params: ["sid1": LogicAdjust.campaign])
            .addParams(params: ["sid2": LogicAdjust.creative])
            .addParams(params: ["sid3": LogicAdjust.adgroup])
            .addParams(params: ["app_sid1": idfa])
            .addParams(params: ["app_sid2": self.appID])
            .addParams(params: ["app_sid3": LogicAdjust.adid])
    }
    
}
