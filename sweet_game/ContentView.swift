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
    
    var body: some View {
        RouterView(router: self.router) {
            LaunchView()
        }
    }
    
}
