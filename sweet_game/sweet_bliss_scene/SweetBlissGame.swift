//
//  SweetBlissGame.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI

struct SweetBlissGame: View {
    
    @State private var basketPosition: BasketPosition = .center
    @Injected(\.router) private var router
    
    let level: SweetBlissGameLevel
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                self.backingBackgroundView(proxy.size).offset(y: proxy.size.height - 190)
                self.basketView().offset(x: self.makeBasketXOffset(proxy.size), y: proxy.size.height - 240)
                self.controlBasketButtonsView().offset(y: proxy.size.height - 235)
                VStack {
                    HStack {
                        BackButtonView() {
                            self.router.presentFullScreen(.showSweetBlissLevels)
                        }
                        Spacer(minLength: 1)
                        BalanceRowView()
                        Spacer(minLength: 1)
                        PauseButtonView() {
                            
                        }
                    }
                    
                    self.betTopView(size: proxy.size)
                }
                .offset(y: 40)
                .padding(.horizontal)
            }
        }
        .background(Image(R.image.app_background.name).resizable().scaledToFill())
        .ignoresSafeArea()
        .onDisappear {
            SweetBlissGameLevelBusines.unlockNextLevel(current: self.level)
        }
    }
    
    private func basketView() -> some View {
        Image(R.image.bliss_game_busket.name)
    }
    
    private func controlBasketButtonsView() -> some View {
        HStack {
            self.leftArrowView()
            Spacer(minLength: 0)
            self.rightArrowView()
        }
    }
    
    private func leftArrowView() -> some View {
        Button(action: {
            withAnimation {
                switch self.basketPosition {
                case .center:
                    self.basketPosition = .leading
                case .trailing:
                    self.basketPosition = .center
                default:
                    break
                }
            }
        }, label: {
            Image(R.image.left_arrow.name)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .padding(.leading, 10)
        })
    }
    
    private func rightArrowView() -> some View {
        Button(action: {
            withAnimation {
                switch self.basketPosition {
                case .center:
                    self.basketPosition = .trailing
                case .leading:
                    self.basketPosition = .center
                default:
                    break
                }
            }
        }, label: {
            Image(R.image.right_arrow.name)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .padding(.trailing, 10)
        })
    }
    
    private func backingBackgroundView(_ viewSize: CGSize) -> some View {
        Image(R.image.backing.name)
            .resizable()
            .scaledToFit()
            .frame(width: viewSize.width, height: viewSize.height / 4)
    }
    
    private func betTopView(size: CGSize) -> some View {
        Image(R.image.bet_top.name)
            .resizable()
            .frame(width: size.width - 40, height: 65)
    }
}

extension SweetBlissGame {
    
    enum BasketPosition {
        case leading
        case trailing
        case center
    }
    
    private func makeBasketXOffset(_ viewSize: CGSize) -> CGFloat {
        switch self.basketPosition {
        case .center:
            return 0
        case .leading:
            return -viewSize.width/4
        case .trailing:
            return viewSize.width/4
        }
    }
}

#Preview {
    SweetBlissGame(level: .init(level: 1))
}
