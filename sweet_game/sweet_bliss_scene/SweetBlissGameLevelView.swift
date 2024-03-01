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
    
    @State private var showErrorToStart: Bool = false
    
     let columns = [
         GridItem(.adaptive(minimum: 80))
     ]

     var body: some View {
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
             .padding(.horizontal)
             
             ScrollView {
                 LazyVGrid(columns: columns, spacing: 10) {
                     ForEach(self.levelsMuttable, id: \.self) { data in
                         LevelRow(data: data) {
                             switch data.unlocked {
                             case .unlocked, .finished:
                                 if SweetGameLevelBusines.heartRate > 0 {
                                     self.router.presentFullScreen(.showSweetBlissGame(data))
                                 } else {
                                     self.showErrorToStart = true
                                 }
                             default:
                                 break
                             }
                         }
                     }
                 }
             }
             .padding(.horizontal)
         }
         .background(Image(R.image.app_background.name).scaleEffect(1.2))
         
         .onAppear {
             self.onStart()
         }
         
         .simpleToast(isPresented: self.$showErrorToStart, options: .init(alignment: .center, dismissOnTap: false, edgesIgnoringSafeArea: .all)) {
             ErrorMessage {
                 self.router.presentFullScreen(.shopShop)
             }
             .padding()
         }
     }
    
    private func onStart() {
        if SweetGameLevelBusines.levels.isEmpty {
            SweetGameLevelBusines.levels = (1...30).map { SweetBlissGameLevel(level: $0)}
        }
        self.levelsMuttable = SweetGameLevelBusines.levels
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
            .resizable()
            .scaledToFit()
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
