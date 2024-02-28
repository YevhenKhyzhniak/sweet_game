//
//  LaunchView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var progressValue = 0.0
    
    var body: some View {
        Image(R.image.app_background.name).resizable().scaledToFill()
        .ignoresSafeArea()
        .overlay(
            Image(R.image.launch_logo.name)
        )
        .overlay(
            ProgressView(value: progressValue, total: 100.0)
                .padding(.bottom, 50)
                .padding(.horizontal)
                .tint(.green)
                .scaleEffect(x: 1, y: 4, anchor: .center), alignment: .bottom
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
                }
            }
        }
    }
}

#Preview {
    LaunchView()
}
