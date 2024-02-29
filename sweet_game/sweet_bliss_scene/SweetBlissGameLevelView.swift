//
//  SweetBlissGameLevelView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 29.02.2024.
//

import SwiftUI

struct SweetBlissGameLevelView: View {
    
    @Injected(\.router) private var router
    @State private var levelsMuttable: [SweetBlissGameLevel] = []
    
     let columns = [
         GridItem(.adaptive(minimum: 80))
     ]

     var body: some View {
         ZStack {
             Image(R.image.app_background.name).resizable().scaledToFill()
             VStack(spacing: 10) {
                 HStack(spacing: 10) {
                     BackButtonView() {
                         self.router.presentFullScreen(.showMain)
                     }
                     Spacer(minLength: 1)
                     TopView(title: "Levels")
                         .padding(.trailing, 40)
                     Spacer(minLength: 1)
                 }
                 
                 ScrollView {
                     LazyVGrid(columns: columns, spacing: 10) {
                         ForEach(self.levelsMuttable, id: \.self) { data in
                             LevelRow(data: data) {
                                 switch data.unlocked {
                                 case .unlocked, .finished:
                                     self.router.presentFullScreen(.showSweetBlissGame(data))
                                 default:
                                     break
                                 }
                             }
                         }
                     }
                 }
             }
             .padding(.horizontal)
             .padding(.top, 60)
         }
         .ignoresSafeArea()
         
         .onAppear {
             self.onStart()
         }
     }
    
    private func onStart() {
        if SweetBlissGameLevelBusines.levels.isEmpty {
            SweetBlissGameLevelBusines.levels = (1...30).map { SweetBlissGameLevel(level: $0)}
        }
        self.levelsMuttable = SweetBlissGameLevelBusines.levels
    }
}

struct LevelRow: View {
    
    let data: SweetBlissGameLevel
    let action: () -> Void
    
    var body: some View {
        self.imageView()
            .overlay(Text(self.data.levelString).bold().foregroundColor(.white))
            .contentShape(Rectangle())
            .onTapGesture {
                self.action()
            }
    }
    
    @ViewBuilder
    private func imageView() -> some View {
        switch self.data.unlocked {
        case .unlocked, .finished:
            Image(R.image.level_row_locked.name).resizable().scaledToFit().frame(width: 70, height: 70)
        default:
            Image(R.image.level_row_unlocked.name).resizable().scaledToFit().frame(width: 70, height: 70)
        }
    }
}

struct TopView: View {
    
    let title: String
    
    var body: some View {
        Image(R.image.balance_row.name)
            .overlay(
                self.overlayContent()
            )
    }
    
    private func overlayContent() -> some View {
        Text(self.title).font(.footnote).bold().foregroundColor(.white)
    }
}

#Preview {
    SweetBlissGameLevelView()
}
