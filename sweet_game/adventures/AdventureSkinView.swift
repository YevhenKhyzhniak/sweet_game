//
//  AdventureSkinView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 12.03.2024.
//

import SwiftUI

struct Tiger: Codable, Identifiable {
    
    static func == (lhs: Tiger, rhs: Tiger) -> Bool {
        return lhs.price == rhs.price
    }
    
    init(price: Int, skin: String) {
        self.price = price
        self.unlocked = price == 0 ? .unlocked : .locked
        self.isSelected = price == 0 ? true : false
        self.skin = skin
    }
    var id: UUID = UUID()
    let price: Int
    let skin: String
    var isSelected: Bool
    
    var unlocked: State
    
    
    var priceString: String {
        return String(format: "%d", price)
    }
    
    enum State: Codable, Hashable {
        case locked
        case unlocked
        case finished
    }
    
}

struct AdventureSkinView: View {
    
    @Injected(\.router) private var router
    
    @State private var tigers: [Tiger] = []
    
    @State private var coins: Int = 0 {
        willSet {
            GamesBusines.coins = newValue
        }
    }
    
    var body: some View {
        self.contentView()
            .background(Image("adventure_bg").resizable().scaleEffect(1.2))
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
            
            Image("adventure_holder").resizable().frame(height: 200)
            
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
                    self.router.presentFullScreen(.adventures(skin: selected.skin))
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
                let result = GamesBusines.unlockNextAdventureTiger(current: t)
                self.tigers = result
                GamesBusines.tigersAdventure = result
                self.coins -= t.price
            }
        } else if t.isSelected {
            //
        } else {
            self.tigers = GamesBusines.changeSelectedAdventureTiger(current: t)
             GamesBusines.tigersAdventure = self.tigers
        }
    }
    
    private func generateItems() {
        guard GamesBusines.tigersAdventure.isEmpty else {
            self.tigers = GamesBusines.tigersAdventure
            return
        }
        
        self.tigers = [
            Tiger.init(price: 0, skin: "tiger_set_1"),
            Tiger.init(price: 350, skin: "tiger_set_2"),
            Tiger.init(price: 500, skin: "tiger_set_3"),
            Tiger.init(price: 750, skin: "tiger_set_4")
        ]
        
        GamesBusines.tigersAdventure = self.tigers
    }
    
}
