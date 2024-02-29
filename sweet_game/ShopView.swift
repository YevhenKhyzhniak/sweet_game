//
//  ShopView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct ShopView: View {
    
    @Injected(\.router) private var router
    
    var body: some View {
        ZStack {
            Image(R.image.app_background.name).resizable().scaledToFill()
            VStack {
                HStack(spacing: 10) {
                    BackButtonView() {
                        self.router.presentFullScreen(.showMain)
                    }
                    Spacer(minLength: 1)
                    TopView(title: "Shop")
                        .padding(.trailing, 40)
                    Spacer(minLength: 1)
                }
                .padding([.horizontal, .bottom])
                
                
                Image(R.image.main_row.name)
                    .resizable()
                    .overlay(
                        self.overlayContent()
                    )
                    .frame(width: UIScreen.main.bounds.width - 40, height: 150)
                
                Spacer(minLength: 1)
            }
            .padding(.top, 60)
            .padding(.bottom, 60)
        }
        .ignoresSafeArea()
    }
    
    private func overlayContent() -> some View {
        VStack(spacing: 10) {
            HStack {
                Image(R.image.heart.name)
                VStack {
                    Group {
                        Text("Extra life").foregroundColor(.white)
                        Text("+25% life").font(.footnote).foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 1)
                
                VStack {
                    Group {
                        Text("You have: ").font(.footnote).foregroundColor(.white) + Text(String(format: "%d%@", 75, "%")).font(.footnote).foregroundColor(.pink)
                        Text("Price: ").font(.footnote).foregroundColor(.white) + Text("120 candy").font(.footnote).foregroundColor(.pink)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(.trailing)
                }
            }
            .padding(.top, 15)
            
            ButtonView(title: "BUY") {
                //
            }
            .scaleEffect(0.9)
        }
        .padding()
        .padding(.leading)
    }
}

#Preview {
    ShopView()
}
