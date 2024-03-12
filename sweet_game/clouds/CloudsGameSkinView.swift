//
//  CloudsGameSkinView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 12.03.2024.
//

import Foundation
import SwiftUI

struct CloudsGameSkinView: View {
    
    @Injected(\.router) private var router
    
    @State private var tigers: [Tiger] = []
    
    @State private var coins: Int = 0 {
        willSet {
            GamesBusines.coins = newValue
        }
    }
    
    var body: some View {
        self.contentView()
            .background(Image("clouds_bg").resizable().scaleEffect(1.2))
            .onAppear {
                self.generateItems()
                self.coins = GamesBusines.coins
            }
    }
    
    private func contentView() -> some View {
        VStack {
            
            HStack(spacing: 20) {
                BackButtonView() {
                    DispatchQueue.main.async {
                        AdventureGameControl.onStart.send(false)
                    }
                    self.router.presentFullScreen(.showMain)
                }
                Spacer(minLength: 1)
                BalanceRowView(balance: self.coins)
                    .padding(.leading, 40)
                SettingsButtonView() {
                    self.router.presentFullScreen(.showSettings)
                }.padding(.trailing)
            }
            
            Image("clouds_holder").resizable().frame(height: 200)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(self.tigers, id: \.id) { tiger in
                        VStack {
                            Image(tiger.skin).opacity(tiger.unlocked == .locked ? 0.5 : 1.0)
                            ButtonView(title: self.makeButtonTitle(tiger)) {
                                DispatchQueue.main.async {
                                    self.makeButtonAction(tiger)
                                }
                            }
                            .frame(height: 50)
                        }
                    }
                }
            }
            
            Spacer(minLength: 3)
            
            ButtonView(title: "PLAY") {
                if let selected = self.tigers.filter({ $0.isSelected }).first {
                    self.router.presentFullScreen(.clouds(skin: selected.skin))
                }
            }
            .frame(height: 50)
        }
        .padding()
    }
    
    private func makeButtonTitle(_ t: Tiger) -> String {
        if t.unlocked == .locked {
            return t.priceString
        } else if t.isSelected {
            return "SELECTED"
        } else {
            return "CHOOSE"
        }
    }
    
    private func makeButtonAction(_ t: Tiger) {
        if t.unlocked == .locked {
            if self.coins >= t.price {
                let result = GamesBusines.unlockNextAdventureTiger(current: t, list: self.tigers)
                self.tigers = result
                GamesBusines.tigersCloud = result
                self.coins -= t.price
            }
        } else if t.isSelected {
            //
        } else {
            self.tigers = GamesBusines.changeSelectedAdventureTiger(current: t, list: self.tigers)
             GamesBusines.tigersCloud = self.tigers
        }
    }
    
    private func generateItems() {
        guard GamesBusines.tigersCloud.isEmpty else {
            self.tigers = GamesBusines.tigersCloud
            return
        }
        
        self.tigers = [
            Tiger.init(price: 0, skin: "tiger_cloud_1"),
            Tiger.init(price: 350, skin: "tiger_cloud_2"),
            Tiger.init(price: 500, skin: "tiger_cloud_3"),
            Tiger.init(price: 750, skin: "tiger_cloud_4")
        ]
        
        GamesBusines.tigersCloud = self.tigers
    }
    
}
