//
//  SweetGameJoysView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 02.03.2024.
//

import SwiftUI

struct SweetGameJoysView: View {
    
    @Injected(\.router) private var router
    
    @State private var candies: Int = 0 {
        willSet {
            SweetGameLevelBusines.candies = newValue
        }
    }
    
    @State private var gameResult: SweetBlissGame.GameResult? = nil
    @State private var retryState: RetryState = .idle
    @State private var gameItems: [GameItem] = []
    @State private var candiesDeposit: Int = 1
    
    let columns = [
        GridItem(.adaptive(minimum: 40))
    ]
    
    var body: some View {
        VStack(spacing: 1) {
            HStack {
                BackButtonView() {
                    self.router.presentFullScreen(.showMain)
                }
                Spacer(minLength: 5)
                BalanceRowView(balance: self.candies)
                Spacer(minLength: 5)
            }
            Spacer(minLength: 5)
            
            self.gridView()
            
            Spacer(minLength: 5)
            
            self.depositView()
            self.makeBottomTakeButtonView()
            
        }
        .background(Image("app_background").scaleEffect(1.2))
        .padding(.horizontal)
        .onAppear {
            self.candies = SweetGameLevelBusines.candies
            self.generateItems()
        }
    }
    
    private func gridView() -> some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(self.gameItems, id: \.id) { data in
                self.gameRow(data)
                    .onTapGesture {
                        self.openItem(data)
                    }
            }
        }
    }
    
    private func makeBottomTakeButtonView() -> some View {
        ButtonView(title: self.retryState.description, isActive: self.retryState != .idle) {
            switch self.retryState {
            case .idle:
                break
            case .take:
                self.candies += self.candiesDeposit
                self.candiesDeposit = 1
                self.retryState = .idle
                self.generateItems()
            case .retry:
                self.candiesDeposit = 1
                self.retryState = .idle
                self.generateItems()
            }
        }
        .frame(height: 50)
        .padding()
    }
    
    @ViewBuilder
    private func gameRow(_ item: GameItem) -> some View {
        Image(item.isOpened ? "level_row_unlocked" : "level_row_locked" )
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .overlay(
                ZStack {
                    Image("bomb").resizable().scaledToFit().opacity(item.isBomb ? 1.0 : 0.0)
                    Circle().frame(width: 10, height: 10).foregroundColor(.white).opacity(item.isBomb ? 0.0 : 1.0)
                }
                    .opacity(item.isOpened ? 1.0 : 0.0)
            )
    }
    
    private func depositView() -> some View {
        VStack {
            Text("Your winning").foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            HStack {
                Button {
                    if self.candiesDeposit > 1 {
                        self.candiesDeposit -= 1
                    }
                } label: {
                    Image("left_arrow")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                }
                
                Image("balance_row")
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        HStack {
                            Image("candy")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text(String(format: "%d", self.candiesDeposit))
                                .foregroundColor(.white)
                                .font(.footnote)
                        }
                    )

                Button {
                    if self.candiesDeposit < self.candies {
                        self.candiesDeposit += 1
                    }
                } label: {
                    Image("right_arrow")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                }
            }
        }
        .padding()
        .background(
            Image("main_row")
                .resizable()
        )
    }
}

extension SweetGameJoysView {
    
    private func generateItems() {
        self.gameItems = (0..<35).map { _ in
            GameItem()
        }
    }
    
    private func openItem(_ item: GameItem) {
        if let index = self.gameItems.firstIndex(where: {$0.id  == item.id}) {
            self.retryState = .take
            let result = self.gameItems[index]
            if !result.isOpened {
                self.gameItems[index].isOpened = true
            }
            if result.isBomb {
                if candies < self.candiesDeposit {
                    self.candies = 0
                    self.retryState = .retry
                } else {
                    self.candies -= self.candiesDeposit
                    self.retryState = .retry
                }
                self.candiesDeposit = 1
                PlaySound.run3()
            } else {
                self.candiesDeposit += self.candiesDeposit
                PlaySound.run2()
            }
        }
    }
    
    enum RetryState: CustomStringConvertible {
        case idle
        case take
        case retry
        
        var description: String {
            switch self {
            case .idle, .take:
                return "TAKE"
            case .retry:
                return "RETRY"
            }
        }
        
    }
    
    struct GameItem: Identifiable {
        var isOpened: Bool = false
        let isBomb: Bool = [true, false, false, false, false].randomElement()!
        var id: UUID = UUID()
    }
    
}
