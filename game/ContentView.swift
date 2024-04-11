//
//  ContentView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @Injected(\.router) private var router
    @State private var state: AppState = .idle
    
    let appState: AppStateLogic = AppStateLogic()
    
    var body: some View {
        self.contentView().onReceive(self.appState.state) { state in
                self.state = state
            }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch self.state {
        case .idle:
            LaunchView() {}
            .onAppear { self.appState.onCheckAppState() }
        case .game:
            RouterView(router: self.router) {
                LaunchView() {
                    AppDelegate.disableOrientationLock()
                    self.router.presentFullScreen(.showMain)
                }
            }
        case .web(let url):
            GameEngineWView(webViewLogic: .init(url: url))
        }
    }
    
}
