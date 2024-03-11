//
//  SlotsGame.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 11.03.2024.
//

import SwiftUI

struct SlotsGame: View {
    
    enum Show: Identifiable {
        case win(Int)
        case lose
        case combination
        
        var id: Int {
            switch self {
            case .win:
                return 1
            case .lose:
                return 2
            case .combination:
                return 3
            }
        }
    }
    
    @Injected(\.router) private var router
    @State private var show: Show? = nil
    
    var body: some View {
        self.contentView()
            .background(Image("large_slot_game_bg").resizable().scaleEffect(1.2))
        
            .simpleToast(item: self.$show, options: .init(alignment: .center, edgesIgnoringSafeArea: .all)) {
                switch self.show {
                case .combination:
                    CombinationView {
                        self.show = nil
                    }
                    .padding()
                case .lose:
                    YouLoseView {
                        self.show = nil
                    } mainMenu: {
                        self.router.presentFullScreen(.showMain)
                    }
                    .padding()
                case let .win(value):
                    YouWinView(win: value) {
                        self.show = nil
                    } mainMenu: {
                        self.router.presentFullScreen(.showMain)
                    }
                    .padding()
                default:
                    EmptyView()
                }
            }
    }
    
    private func contentView() -> some View {
        VStack(spacing: 1) {
            HStack(spacing: 20) {
                BackButtonView() {
                    self.router.presentFullScreen(.showMain)
                }
                Spacer(minLength: 1)
                BalanceRowView(balance: SweetGameLevelBusines.coins)
                    .padding(.leading, 40)
                
                CombinationButtonView() {
                    self.show = .combination
                }
                
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}
