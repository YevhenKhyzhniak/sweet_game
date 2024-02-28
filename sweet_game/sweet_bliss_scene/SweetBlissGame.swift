//
//  SweetBlissGame.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI

struct SweetBlissGame: View {
    
    @State private var ratio: CGFloat = 0
    @State private var startX: CGFloat? = nil
    
    var body: some View {
        GeometryReader { proxy in
            self.basketView()
                .offset(x: self.startX == nil ? proxy.size.width / 4 : (proxy.size.width / 2) * ratio, y: proxy.size.height - 150)
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged({ update(value: $0, proxy: proxy) }))
        }
        .background(Image(R.image.app_background.name).resizable().scaledToFill())
        .ignoresSafeArea()
    }
    
    private func basketView() -> some View {
        Image(R.image.bliss_game_busket.name)
    }
}

extension SweetBlissGame {
    
    private func update(value: DragGesture.Value, proxy: GeometryProxy) {
        debugPrint(value, proxy)
        if startX == nil {
            startX = value.translation.width / 4
        }
        
        var point = value.location.x - startX!
        let delta = proxy.size.width
        
        if point < 0 {
            startX = value.location.x
            point = 0
            
        } else if delta < point {
            startX = value.location.x - delta
            point = delta
        }
        
        var ratio = point / delta
        
        self.ratio = ratio
    }
    
}

#Preview {
    SweetBlissGame()
}
