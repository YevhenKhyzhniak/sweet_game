//
//  WebView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 07.03.2024.
//

import Foundation
import SwiftUI

struct WebView: View {
    
    let webViewLogic: LogicWebView
    @State private var state: LogicWebViewState = .inProcess
    
    var body: some View {
        self.contentView()
            .ignoresSafeArea(.all)
            .onReceive(self.webViewLogic.state) { state in
                self.state = state
            }
            .onAppear {
                self.webViewLogic.onStart()
            }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        switch self.state {
        case .inProcess:
            ProgressView()
        case .playGame(let uRLRequest):
            WebRepresentable(request: uRLRequest) { url in
                self.webViewLogic.dynamicURL = url
            }
        }
    }
}
