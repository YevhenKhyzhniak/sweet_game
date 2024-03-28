//
//  LaunchView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var progressValue = 0.0
    @Injected(\.router) private var router
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Image("app_background").resizable().scaleEffect(1.2)
            .ignoresSafeArea()
            .overlay(
                Image("logo").resizable().frame(width: 250, height: 250)
            )
            .overlay(
                VStack(spacing: 10) {
                    ProgressView(value: progressValue, total: 100.0)
                        .padding(.horizontal)
                        .tint(.blue.opacity(0.7))
                        .scaleEffect(x: 1, y: 3, anchor: .center)
                        .opacity(self.progressValue < 100 ? 1.0 : 0.0)
                    
                    Text("Loading...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.blue.opacity(0.7))
                        .padding(.bottom, 20)
                        .opacity(self.progressValue < 100 ? 1.0 : 0.0)
                }
                , alignment: .bottom
            )
        
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    if progressValue < 100 {
                        let randomIncrement = [20.0, 5.0, 25.0, 50.0, 1.0, 10.0].randomElement()!
                        
                        var copyProgress = progressValue
                        copyProgress += randomIncrement
                        
                        if copyProgress > 100 {
                            copyProgress = 100
                        }
                        progressValue = copyProgress
                        
                    } else {
                        timer.invalidate()
                        self.action()
                    }
                }
            }
    }
}
