//
//  MainView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct MainView: View {
    
    @Injected(\.router) private var router
    @State private var showSettings: Bool = false
    
    var body: some View {

        VStack(spacing: 1) {
            
            HStack {
                Spacer(minLength: 8)
                BalanceRowView(balance: SweetGameLevelBusines.candies)
                    .padding(.leading, 40)
                Spacer(minLength: 8)
                SettingsButtonView() {
                    self.showSettings = true
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
                .disabled(self.showSettings)
                
                MainRowView(title: "joys") {
                    self.router.presentFullScreen(.showSweetGameJoys)
                }
                .frame(height: 150)
                .padding(.horizontal, 4)
                .disabled(self.showSettings)
            }
            
            ButtonView(title: "Shop") {
                self.router.presentFullScreen(.showShop)
            }
            .frame(width: UIScreen.main.bounds.width - 60, height: 50)
            .padding(.bottom, 8)
            .disabled(self.showSettings)
        }
        .background(Image(R.image.app_background.name).scaleEffect(1.2))
        .padding(.horizontal)
        .blur(radius: self.showSettings ? 5.0 : 0.0)
        .onTapGesture {
            self.showSettings = false
        }
        
        .simpleToast(isPresented: self.$showSettings, options: .init(alignment: .center, dismissOnTap: true, edgesIgnoringSafeArea: .all)) {
            SettingsView()
            .padding()
        }
    }
}
