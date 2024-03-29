//
//  SettingsButtonView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct SettingsButtonView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image("settings_button")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }

    }
}

struct PauseButtonView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image("pause_button")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }

    }
}
