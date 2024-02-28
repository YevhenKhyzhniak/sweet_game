//
//  SweetBlissGame.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI

struct SweetBlissGame: View {
    
    @State private var basketPosition: BasketPosition = .center
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                self.basketView()
                    .offset(x: self.makeBasketXOffset(proxy.size), y: proxy.size.height - 150)
                HStack {
                    self.leftArrowView()
                    Spacer(minLength: 0)
                    self.rightArrowView()
                }
                .offset(y: proxy.size.height - 150)
            }
        }
        .background(Image(R.image.app_background.name).resizable().scaledToFill())
        .ignoresSafeArea()
    }
    
    private func basketView() -> some View {
        Image(R.image.bliss_game_busket.name)
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
                .padding(.trailing, 10)
        })
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
    SweetBlissGame()
}
