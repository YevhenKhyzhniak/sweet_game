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

public enum LogicViewState {
    case inProcess
    case playGame(URLRequest)
}

public class LogicEngineView {
    
    public let state: PassthroughSubject<LogicViewState, Never> = .init()
    
    public init(url: URL) {
        self.initialUrl = url
    }
    
    private let initialUrl: URL
    
    @Storage(key: "GameView.DynamicKey", defaultValue: nil)
    var dynamicURL: URL?
    
    
    public func onStart() {
        self.state.send(.inProcess)
        if let dynamic = self.dynamicURL {
            self.state.send(.playGame(.init(url: dynamic)))
        } else {
            self.state.send(.playGame(.init(url: self.initialUrl)))
        }
        
    }    
}
