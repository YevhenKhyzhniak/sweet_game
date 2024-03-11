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
        self.overlayContent()
    }
    
    private func overlayContent() -> some View {
        ZStack {
            Text(String(format: "%d", balance)).bold().padding(.horizontal).font(.footnote).foregroundColor(.white)
                .background(
                    Image("balance_row").resizable().frame(height: 30)
                )
            Image("coins").resizable().frame(width: 40, height: 40).offset(x: -40)
        }
    }
}

