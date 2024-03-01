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
        //ZStack {
            //Image(R.image.app_background.name)
            VStack(spacing: 1) {
                
                HStack {
                    Spacer(minLength: 1)
                    BalanceRowView()
                        .padding(.leading, 40)
                    Spacer(minLength: 1)
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
                    
                    MainRowView(title: "joys") {
                        
                    }
                }
                
                ButtonView(title: "Shop") {
                    self.router.presentFullScreen(.shopShop)
                }
            }
            .background(Image(R.image.app_background.name).scaleEffect(1.2))
            .padding(.horizontal)
        //}
       // .ignoresSafeArea()
    }
}

#Preview {
    MainView()
}
