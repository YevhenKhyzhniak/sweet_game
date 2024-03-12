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
            
            HStack(spacing: 20) {
                Spacer(minLength: 8)
                BalanceRowView(balance: GamesBusines.coins)
                    .padding(.leading, 40)
                SettingsButtonView() {
                    self.router.presentFullScreen(.showSettings)
                }.padding(.trailing)
            }
            
            Spacer(minLength: 1)
            
            ZStack {
                VStack {
                    Image("logo_full")
                        .resizable()
                        .scaledToFit()
                        .frame(height: UIScreen.main.bounds.height / 2)
                    Spacer()
                }
                
                VStack {
                    Spacer(minLength: 1)
                    HStack(spacing: 0) {
                        Button(action: {
                            self.router.presentFullScreen(.largeSlot)
                        }, label: {
                            Image("large_slots")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
                                .offset(x: 20)
                        })

                        VStack(spacing: 10) {
                            Button {
                                self.router.presentFullScreen(.adventuresSkin)
                            } label: {
                                Image("adventures")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width / 2.4, height: UIScreen.main.bounds.height / 4.1)
                                    .offset(x: -25)
                            }

                            Button(action: {
                                self.router.presentFullScreen(.cloudsSkin)
                            }, label: {
                                Image("clouds")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width / 2.1, height: UIScreen.main.bounds.height / 4.1)
                                    .offset(x: -40)
                            })
                        }
                        .frame(height: UIScreen.main.bounds.height / 2)
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                }
                .padding(.bottom)
            }
        }
        .background(Image("app_background").resizable().scaleEffect(1.2))
        .padding(.horizontal)
    }
}
