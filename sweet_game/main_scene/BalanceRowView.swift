//
//  BalanceRowView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct BalanceRowView: View {
    
    let balance: Int
    
    var body: some View {
        Image("balance_row")
            .resizable()
            .scaledToFit()
            .overlay(
                self.overlayContent()
            )
    }
    
    private func overlayContent() -> some View {
        HStack {
            Text("Balance:").font(.footnote).bold().padding(.trailing, 5).foregroundColor(.white)
            Image("candy")
            Text(String(format: "%d", balance)).font(.footnote).bold().foregroundColor(.white)
        }
    }
}

