//
//  BackButtonView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import Foundation
import SwiftUI

struct BackButtonView: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image("left_arrow")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }

    }
}
