//
//  ShopButtonView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct ShopButtonView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(R.image.shop_button.name)
                .resizable()
                .overlay(
                    self.overlayContent()
                )
                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
        }

    }
    
    private func overlayContent() -> some View {
        Text("Shop").bold().foregroundColor(.white)
    }
}

#Preview {
    ShopButtonView() {}
}
