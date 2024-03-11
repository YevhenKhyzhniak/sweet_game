//
//  ButtonView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct ButtonView: View {
    
    init(title: String, isActive: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isActive = isActive
        self.action = action
    }
    
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(self.isActive ? "shop_button" : "inactive_button")
                .resizable()
                .overlay(
                    self.overlayContent()
                )
        }

    }
    
    private func overlayContent() -> some View {
        Text(self.title).bold().padding(.vertical, 8).foregroundColor(Color("color_red", bundle: .main))
    }
}
