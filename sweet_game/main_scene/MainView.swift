//
//  MainView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct MainView: View {
    
    @Injected(\.router) private var router
    
    var body: some View {

        VStack(spacing: 1) {
            
            HStack {
                Spacer(minLength: 8)
                BalanceRowView(balance: SweetGameLevelBusines.candies)
                    .padding(.leading, 40)
                Spacer(minLength: 8)
                SettingsButtonView() {
                    
                }.padding(.trailing)
            }
            
            ScrollView(showsIndicators: false) {
                
                Spacer(minLength: 1)
                
                Image(R.image.launch_logo.name)
                    .resizable()
                    .scaledToFit()
                    .frame(height: UIScreen.main.bounds.height / 4)
                    .padding(.vertical, 20)
                
                Spacer(minLength: 1)
                
                MainRowView(title: "bliss") {
                    self.router.presentFullScreen(.showSweetBlissLevels)
                }
                .frame(height: 150)
                .padding(.horizontal, 4)
                
                MainRowView(title: "joys") {
                    
                }
                .frame(height: 150)
                .padding(.horizontal, 4)
            }
            
            ButtonView(title: "Shop") {
                self.router.presentFullScreen(.shopShop)
            }
            .frame(width: UIScreen.main.bounds.width - 60, height: 50)
            .padding(.bottom, 8)
        }
        .background(Image(R.image.app_background.name).scaleEffect(1.2))
        .padding(.horizontal)
    }
}

#Preview {
    MainView()
}
