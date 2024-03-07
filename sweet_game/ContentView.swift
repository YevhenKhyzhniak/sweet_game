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
    let appState: AppStateLogic
    let initURLConst = "https://www.google.com/" // для перевірки запуску гри
    
    init() {
        self.appState = AppStateLogic(redirect: RedirectLogicImpl(), initURLConst: self.initURLConst)
    }
    
    var body: some View {
        self.contentView()
            .onAppear {
                self.appState.onCheckAppState()
            }
            .onReceive(self.appState.state) { state in
                debugPrint("App State Receive - \(state.self)")
                self.state = state
            }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch self.state {
        case .idle:
            LaunchView() {}
        case .game:
            RouterView(router: self.router) {
                LaunchView() {
                    self.router.presentFullScreen(.showMain)
                }
            }
        case .web(let url):
            WebView(webViewLogic: .init(url: url))
        }
    }
    
}
