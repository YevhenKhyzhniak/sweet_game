//
//  SlotsGame.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 11.03.2024.
//

import SwiftUI

enum SlotItem: String, CaseIterable, Hashable {
    case bag
    case cards
    case dinamite
    case dragon
    case fish
    case globe
    case gold
    case jandj
    case plate
    
    static var randomValues: [SlotItem] {
        var result: [SlotItem] = []
        for _ in 0...100 {
            result.append(SlotItem.allCases.randomElement()!)
        }
        return result
    }
}

struct SlotsGame: View {
    
    enum Show: Identifiable {
        case win(Int)
        case lose
        case combination
        
        var id: Int {
            switch self {
            case .win:
                return 1
            case .lose:
                return 2
            case .combination:
                return 3
            }
        }
    }
    
    @Injected(\.router) private var router
    @State private var show: Show? = nil
    
    @State private var coins: Int = 0 {
        willSet {
            GamesBusines.coins = newValue
        }
    }
    
    @State private var firstSlot: SlotItem = .bag
    @State private var secondSlot: SlotItem = .fish
    @State private var thirdSlot: SlotItem = .jandj
    
    @State private var depositeCoins: Int = 1
    
    @State var allValuesOnSlots: [SlotItem] = []
    
    var body: some View {
        self.contentView()
            .blur(radius: self.show != nil ? 5.0 : 0.0)
            .onAppear {
                self.coins = GamesBusines.coins
                self.allValuesOnSlots = SlotItem.randomValues
            }
            .background(Image("large_slot_game_bg").resizable().scaleEffect(1.2))
        
            .simpleToast(item: self.$show, options: .init(alignment: .center, edgesIgnoringSafeArea: .all)) {
                switch self.show {
                case .combination:
                    CombinationView {
                        self.show = nil
                    }
                    .padding()
                case .lose:
                    YouLoseView {
                        self.show = nil
                    } mainMenu: {
                        self.router.presentFullScreen(.showMain)
                    }
                    .padding()
                case let .win(value):
                    YouWinView(win: value) {
                        self.show = nil
                    } mainMenu: {
                        self.router.presentFullScreen(.showMain)
                    }
                    .padding()
                default:
                    EmptyView()
                }
            }
    }
    
    private func contentView() -> some View {
        VStack(spacing: 1) {
            HStack(spacing: 20) {
                BackButtonView() {
                    self.router.presentFullScreen(.showMain)
                }
                Spacer(minLength: 1)
                BalanceRowView(balance: self.coins)
                    .padding(.leading, 40)
                
                CombinationButtonView() {
                    self.show = .combination
                }
                
            }
            .padding(.horizontal, 20)
            
            self.slotsGameDecorateView()
                .overlay(self.slotsView().padding(8).offset(y: 30).disabled(true))
                .overlay(
                    ButtonView(title: "PLAY") {
                        self.spinSlots()
                    }
                    .frame(width: UIScreen.main.bounds.width / 3, height: 50).offset(y: -30), alignment: .bottom
                )
            
            Spacer(minLength: 2)
            
            self.depositeView()
                .padding([.horizontal, .bottom])
            
        }
    }
    
    private func slotsGameDecorateView() -> some View {
        Image("slots_game_decorate").resizable()
    }
    
    private func slotsView() -> some View {
        HStack {
            Picker("", selection: $firstSlot) {
                ForEach(self.allValuesOnSlots, id: \.self) { value in
                    Image(value.rawValue)
                        .resizable() // Make the image resizable
                        .frame(width: 25, height: 25) // Set the desired size
                        .tag(value.rawValue)
                }
            }
            .clipped()
            .frame(width: 80, height: 120)
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            .scaledToFit()
            .scaleEffect(CGSize(width: 2.0, height: 2.0))
            
            Picker("", selection: $secondSlot) {
                ForEach(self.allValuesOnSlots, id: \.self) { value in
                    Image(value.rawValue)
                        .resizable() // Make the image resizable
                        .frame(width: 25, height: 25) // Set the desired size
                        .tag(value.rawValue)
                }
            }
            .clipped()
            .frame(width: 80, height: 120)
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            .scaledToFit()
            .scaleEffect(CGSize(width: 2.0, height: 2.0))
            
            Picker("", selection: $thirdSlot) {
                ForEach(self.allValuesOnSlots, id: \.self) { value in
                    Image(value.rawValue)
                        .resizable() // Make the image resizable
                        .frame(width: 25, height: 25) // Set the desired size
                        .tag(value.rawValue)
                }
            }
            .clipped()
            .frame(width: 80, height: 120)
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            .scaledToFit()
            .scaleEffect(CGSize(width: 2.0, height: 2.0))
            
        }
        .padding()
        .padding(.vertical, 30)
        .background(Image("slots_game_field").resizable())
    }
    
    private func depositeView() -> some View {
        VStack(spacing: 20) {
            Text("Count:").bold().frame(maxWidth: .infinity, alignment: .center).foregroundColor(.white).padding(.top)
            HStack(spacing: 20) {
                Button {
                    if self.depositeCoins > 1 {
                        self.depositeCoins -= 1
                    }
                } label: {
                    Image("left_arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                
                Text("\(depositeCoins)").frame(maxWidth: .infinity, alignment: .center).padding(.horizontal, 30).padding(.vertical, 10).foregroundColor(.white)
                    .background(
                        Image("balance_row")
                            .resizable()
                    )
                
                Button {
                    if self.depositeCoins < self.coins {
                        self.depositeCoins += 1
                    }
                } label: {
                    Image("right_arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 10)
        }.background(Image("deposite_bg").resizable())
    }
    
    
    private func spinSlots() {
        if coins < self.depositeCoins {
            self.show = .lose
        } else {
            PlaySound.run2()
            withAnimation {
                self.firstSlot = SlotItem.allCases.randomElement()!
                self.secondSlot = SlotItem.allCases.randomElement()!
                self.thirdSlot = SlotItem.allCases.randomElement()!
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.makeResult()
                }
            }
        }
    }
    
    private func makeResult() {
        let allSelectedSlots = [self.firstSlot, self.secondSlot, self.thirdSlot]
        
        if (self.firstSlot == .fish && self.secondSlot == .fish) || (self.secondSlot == .fish && self.thirdSlot == .fish)
            || (self.firstSlot == .plate && self.secondSlot == .plate) || (self.secondSlot == .plate && self.thirdSlot == .plate)
            || (self.firstSlot == .cards && self.secondSlot == .cards) || (self.secondSlot == .cards && self.thirdSlot == .cards) {
            
            if coins < self.depositeCoins {
                self.coins = 0
                self.depositeCoins = 1
                self.show = .lose
            } else {
                self.coins -= self.depositeCoins
            }
            PlaySound.run3()
            
        } else {
            if allSelectedSlots == [.dinamite, .dinamite, .dinamite] {
                self.coins += self.depositeCoins * 2
                self.show = .win(self.depositeCoins * 2)
                PlaySound.run4()
            } else if allSelectedSlots == [.bag, .bag, .bag] {
                self.coins += self.depositeCoins * 3
                self.show = .win(self.depositeCoins * 3)
                PlaySound.run4()
            } else if allSelectedSlots == [.dragon, .dragon, .dragon] {
                self.coins += self.depositeCoins * 4
                self.show = .win(self.depositeCoins * 4)
                PlaySound.run4()
            } else if allSelectedSlots == [.gold, .gold, .gold] {
                self.coins += self.depositeCoins * 5
                self.show = .win(self.depositeCoins * 5)
                PlaySound.run4()
            } else if allSelectedSlots == [.jandj, .jandj, .jandj] {
                self.coins += self.depositeCoins * 6
                self.show = .win(self.depositeCoins * 6)
                PlaySound.run4()
            } else if allSelectedSlots == [.globe, .globe, .globe] {
                self.coins += self.depositeCoins * 7
                self.show = .win(self.depositeCoins * 7)
                PlaySound.run4()
            } else {
                if (self.firstSlot == .globe && self.secondSlot == .globe) || (self.secondSlot == .globe && self.thirdSlot == .globe)
                    || (self.firstSlot == .jandj && self.secondSlot == .jandj) || (self.secondSlot == .jandj && self.thirdSlot == .jandj)
                    || (self.firstSlot == .dragon && self.secondSlot == .dragon) || (self.secondSlot == .dragon && self.thirdSlot == .dragon) {
                    self.coins += self.depositeCoins
                    PlaySound.run4()
                }
            }
        }
    }
}
