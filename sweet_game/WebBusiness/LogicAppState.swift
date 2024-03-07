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
            var result: AppState
            
            do {
                let redirectURL = try await self.redirect.getRedirectionUrl(URLRequest(url: initialURL))
                result = initialURL != redirectURL ? .web(redirectURL) : .game
            } catch {
                result = .game
            }
            
            self.appState = result
            await MainActor.run {
                self.state.send(self.appState)
            }
        }
    }
    
}
