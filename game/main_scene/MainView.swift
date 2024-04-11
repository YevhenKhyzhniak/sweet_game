//
//  MainView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct MainView: View {
    
    enum Show: Identifiable {
        case settings
        case reward
        
        var id: Int {
            switch self {
            case .settings:
                return 1
            case .reward:
                return 2
            }
        }
    }
    
    @Injected(\.router) private var router
    
    @State private var show: Show? = nil
    
    var body: some View {

        ZStack {
            Image("app_background").resizable().scaleEffect(1.2)
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        self.show = .reward
                    }, label: {
                        Image("daily_reward_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 60)
                    })
                    
                    Button(action: {
                        self.router.presentFullScreen(.playRouletteCafeCasino)
                    }, label: {
                        Image("play_roulette")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 60)
                    })
                    
                    Spacer(minLength: 1)
                    Button(action: {
                        self.show = .settings
                    }, label: {
                        Image("settings_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                    })
                }
                Spacer(minLength: 1)
                HStack(spacing: 30) {
                    
                    Button(action: {
                        self.router.presentFullScreen(.playGame1CafeCasino)
                    }, label: {
                        Image("game_1_button")
                            .resizable()
                    })
                    
                    Button(action: {
                        self.router.presentFullScreen(.playGame2CafeCasino)
                    }, label: {
                        Image("game_2_button")
                            .resizable()
                    })
                    
                    Button(action: {
                        self.router.presentFullScreen(.playGame3CafeCasino)
                    }, label: {
                        Image("game_3_button")
                            .resizable()
                    })
                    
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .blur(radius: self.show != nil ? 5.0 : 0.0)
            .disabled(self.show != nil)
        }
        .simpleToast(item: self.$show, options: .init(alignment: .center, edgesIgnoringSafeArea: .all)) {
            switch self.show {
            case .settings:
                SettingsCafe()
                    .overlay(
                        Button(action: {
                            self.show = nil
                        }, label: {
                            Image("close_button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                        }), alignment: .topTrailing
                    )
                    .padding()
            case .reward:
                DailyRewardView()
                    .overlay(
                        Button(action: {
                            self.show = nil
                        }, label: {
                            Image("close_button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                        }), alignment: .topTrailing
                    )
                    .padding()
            default:
                Color.clear
            }
        }
    }
}
