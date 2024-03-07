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
    
    public init(url: URL) {
        self.initialUrl = url
    }
    
    private let initialUrl: URL
    
    @Storage(key: "LogicWebView.DynamicURLKey", defaultValue: nil)
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
