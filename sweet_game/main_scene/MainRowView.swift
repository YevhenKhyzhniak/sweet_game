//
//  MainRowView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct MainRowView: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(R.image.main_row.name)
                .resizable()
                .overlay(
                    self.overlayContent()
                )
                .frame(width: UIScreen.main.bounds.width - 40, height: 150)
        }
    }
    
    private func overlayContent() -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("Play").foregroundColor(.white)
                Image(R.image.right_arrow_alt.name)
                Spacer(minLength: 1)
            }
            .padding(.top, 15)
            
            Text("Game sweet").font(.title).bold().frame(maxWidth: .infinity, alignment: .leading).multilineTextAlignment(.leading).foregroundColor(.white)
            Text(title).font(.title).bold().frame(maxWidth: .infinity, alignment: .leading).multilineTextAlignment(.leading).foregroundColor(.white)
            
        }
        .padding()
        .padding(.leading)
    }
}

#Preview {
    MainRowView(title: "Game 1") {}
}
