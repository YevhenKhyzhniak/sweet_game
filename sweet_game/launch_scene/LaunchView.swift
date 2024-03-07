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
    
    var body: some View {
        Image(R.image.app_background.name).resizable().scaleEffect(1.2)
        .ignoresSafeArea()
        .overlay(
            Image(R.image.launch_logo.name).resizable().frame(width: 200, height: 200)
        )
        .overlay(
            ProgressView(value: progressValue, total: 100.0)
                .padding(.bottom, 50)
                .padding(.horizontal)
                .tint(.green)
                .scaleEffect(x: 1, y: 4, anchor: .center)
                .opacity(self.progressValue < 100 ? 1.0 : 0.0), alignment: .bottom
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
                    self.router.presentFullScreen(.showMain)
                }
            }
            
            ATTracking.requestTracking()
        }
    }
}
