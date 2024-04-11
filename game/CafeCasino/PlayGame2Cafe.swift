//
//  PlayGame1CafeCasino.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 27.03.2024.
//

import SwiftUI
import Combine

struct PlayGame2Cafe: View {
    
    enum Show: Identifiable {
        case win(Double)
        case lose
        
        var id: Int {
            switch self {
            case .win:
                return 1
            case .lose:
                return 2
            }
        }
    }
    
    enum GameType {
        case auto
        case manual
    }
    
    enum SlotItem: String, CaseIterable, Hashable {
        case game_2_icon_1
        case game_2_icon_2
        case game_2_icon_3
        case game_2_icon_4
        case game_2_icon_5
        case game_2_icon_6
        case game_2_icon_7
        case game_2_icon_8
        case game_2_icon_9
        case game_2_icon_10
        case game_2_icon_11
        case game_2_icon_12
        case game_2_icon_13
        case game_2_icon_14
        case game_2_icon_15
        
        static var randomValues: [SlotItem] {
            var result: [SlotItem] = []
            for _ in 0...50 {
                result.append(SlotItem.allCases.randomElement()!)
            }
            return result
        }
    }
    
    @Injected(\.router) private var router
    
    @State private var show: Show? = nil
    
    @State private var coins: Double = 0 {
        willSet {
            GamesBusines.coins = newValue
        }
    }
    
    @State private var firstSlot: SlotItem = .game_2_icon_4
    @State private var secondSlot: SlotItem = .game_2_icon_7
    @State private var thirdSlot: SlotItem = .game_2_icon_12
    @State private var fourSlot: SlotItem = .game_2_icon_3
    @State private var fiveSlot: SlotItem = .game_2_icon_6
    
    @State var allValuesOnSlots: [SlotItem] = []
    
    @State private var spinsCount: Int = 1
    @State private var winCount: Double = 0
    
    // Timer
    
    @State private var manualSpinTimes = 10
    @State private var autoSpinTimes = 10
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    @State private var timerSubscription: AnyCancellable?
    @State private var timerActive = false
    
    var body: some View {
        ZStack {
            Image("game_2_background").resizable().scaleEffect(1.2)
            self.contentView()
                .blur(radius: self.show != nil ? 5.0 : 0.0)
        }
        .onAppear {
            self.coins = GamesBusines.coins
            self.allValuesOnSlots = SlotItem.randomValues
        }
        .onDisappear {
            self.timerSubscription?.cancel()
            self.coins += self.winCount
        }
        .simpleToast(item: self.$show, options: .init(alignment: .center, edgesIgnoringSafeArea: .all)) {
            switch self.show {
            case .lose:
                VStack(spacing: 15) {
                    Text("SO SORRY...").bold().foregroundColor(.white)
                    
                    Text("YOU DON'T HAVE ENOUGH COINS. PLEASE CHECK DAILY REWARD TO RECEIVE BONUS COINS").bold().foregroundColor(.white)
                    
                    Button {
                        self.show = nil
                        self.router.presentFullScreen(.showMain)
                    } label: {
                        Text("CHECK DAILY REWARD")
                            .foregroundColor(.black)
                            .padding()
                            .background(Image("game_1_large_button").resizable())
                    }
                }
                .padding()
                .background(Image("game_1_win_back").resizable())
                .padding()
            case let .win(value):
                VStack(spacing: 15) {
                    Text("YOU WIN!!!").bold().foregroundColor(.white)
                    
                    Text(String(format: "TOTAL WIN: %.2f", self.winCount)).bold().foregroundColor(.white)
                    
                    Button {
                        self.show = nil
                        self.coins += self.winCount
                        self.router.presentFullScreen(.showMain)
                    } label: {
                        Text("TAKE REWARD&CLOSE")
                            .bold()
                            .foregroundColor(.black)
                            .padding()
                            .background(Image("game_1_large_button").resizable())
                    }
                }
                .padding()
                .background(Image("game_1_win_back").resizable())
                .padding()
                .padding()
            default:
                EmptyView()
            }
        }
    }
    
    
    private func contentView() -> some View {
        HStack(spacing: 10) {
            VStack {
                self.balanceRow()
                Spacer(minLength: 1)
                self.slotsView()
                Spacer(minLength: 1)
            }
            VStack {
                Spacer(minLength: 1)
                self.spintsView()
            }
            .padding(.trailing, 8)
        }
        .padding(.leading)
        .padding(.trailing, 5)
        .padding(.vertical, 10)
    }
    
    private func balanceRow() -> some View {
        HStack {
            Button {
                self.router.presentFullScreen(.showMain)
            } label: {
                Image("game_2_back_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
            }
            
            Spacer(minLength: 1)
            
            Text(String(format: "BALANCE: %.2f", self.coins)).bold().padding(.horizontal).font(.footnote).foregroundColor(.white)
                .background(
                    Image("game_2_label_back").resizable().frame(height: 30)
                )
            
            Text(String(format: "TOTAL WIN: %.2f", self.winCount)).bold().padding(.horizontal).font(.footnote).foregroundColor(.white)
                .background(
                    Image("game_2_label_back").resizable().frame(height: 30)
                )
            

        }
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
            
            Picker("", selection: $fourSlot) {
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
            
            Picker("", selection: $fiveSlot) {
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
        .background(Image("game_2_slots_back").resizable())
        .disabled(true)
        .scaleEffect(0.9)
    }
    
    private func spintsView() -> some View {
        VStack(spacing: 15) {
            Text("AUTOSPIN").bold().foregroundColor(.black)
            
            Text(String(format: "TIMES: %d", self.autoSpinTimes)).bold().padding(.horizontal).font(.footnote).foregroundColor(.brown)
                .background(
                    Image("game_2_label_back").resizable().frame(height: 30)
                )
            
            HStack {
                Button {
                    if self.autoSpinTimes > 1 {
                        self.autoSpinTimes -= 1
                    }
                } label: {
                    Image("game_2_small_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .overlay(Text("-").bold().foregroundColor(.brown))
                }

                Button {
                    if self.autoSpinTimes < 20 {
                        self.autoSpinTimes += 1
                    }
                } label: {
                    Image("game_2_small_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .overlay(Text("+").bold().foregroundColor(.brown))
                }
                
            }
            
            Button {
                
                if self.timerActive == false {
                    self.timerActive = true
                    timerSubscription = Timer.publish(every: 1.5, on: .main, in: .common)
                        .autoconnect()
                        .sink { _ in
                            if self.autoSpinTimes > 0 {
                                withAnimation {
                                    self.autoSpinTimes -= 1
                                    self.spinSlots(.auto)
                                }
                            } else {
                                self.timerActive = false
                                self.timerSubscription?.cancel() // Зупинка таймера після 10 ітерацій
                            }
                        }
                } else {
                    self.timerActive = false
                    timerSubscription?.cancel()
                }
                
                
            } label: {
                Image("game_2_large_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .overlay(Text(self.timerActive ? "DISABLE" : "ENABLE").bold().foregroundColor(.brown))
            }
            
            
            Text("YOUR BET")
                .bold()
                .foregroundColor(.black)
            
            Text(String(format: "TIMES: %d", self.manualSpinTimes)).bold().padding(.horizontal).font(.footnote).foregroundColor(.brown)
                .background(
                    Image("game_2_label_back").resizable().frame(height: 30)
                )
            
            HStack {
                Button {
                    if self.manualSpinTimes > 1 {
                        self.manualSpinTimes -= 1
                    }
                } label: {
                    Image("game_2_small_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .overlay(Text("-").bold().foregroundColor(.brown))
                }

                Button {
                    if self.manualSpinTimes < 20 {
                        self.manualSpinTimes += 1
                    }
                } label: {
                    Image("game_2_small_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .overlay(Text("+").bold().foregroundColor(.brown))
                }
                
            }
            
            Button {
                self.spinSlots(.manual)
                if self.manualSpinTimes > 0 {
                    self.manualSpinTimes -= 1
                }
            } label: {
                Image("game_2_large_button")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .overlay(Text("SPIN").bold().foregroundColor(.brown))
            }
        }
        .padding()
        .background(Image("game_2_spin_back").resizable())
    }
    
    private func spinSlots(_ type: GameType) {
        
        if type == .manual && self.manualSpinTimes == 0 {
            if winCount > 0 {
                self.show = .win(winCount)
            }
            return
        }
        if type == .auto && self.autoSpinTimes == 0 {
            if winCount > 0 {
                self.show = .win(winCount)
            }
            return
        }
        
        if coins < self.winCount || coins == 0 {
            self.show = .lose
        } else {
            Playing.run2()
            withAnimation {
                self.firstSlot = SlotItem.allCases.randomElement()!
                self.secondSlot = SlotItem.allCases.randomElement()!
                self.thirdSlot = SlotItem.allCases.randomElement()!
                self.fourSlot = SlotItem.allCases.randomElement()!
                self.fiveSlot = SlotItem.allCases.randomElement()!
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.makeResult()
                }
            }
        }
    }
    
    private func makeResult() {
        let allSelectedSlots = [self.firstSlot, self.secondSlot, self.thirdSlot, self.fourSlot, self.fiveSlot]
        
        if (firstSlot == .game_2_icon_5 && secondSlot == .game_2_icon_5)
        ||  (thirdSlot == .game_2_icon_5 && fourSlot == .game_2_icon_5)
        ||  (secondSlot == .game_2_icon_5 && fourSlot == .game_2_icon_5)
        ||  (firstSlot == .game_2_icon_5 && thirdSlot == .game_2_icon_5)
        ||  (fourSlot == .game_2_icon_5 && fiveSlot == .game_2_icon_5) {
            self.winCount += 10
            Playing.run4()
        }
        else
        if (firstSlot == .game_2_icon_1 && secondSlot == .game_2_icon_1)
        ||  (thirdSlot == .game_2_icon_1 && fourSlot == .game_2_icon_1)
        ||  (secondSlot == .game_2_icon_1 && fourSlot == .game_2_icon_1)
        ||  (firstSlot == .game_2_icon_1 && thirdSlot == .game_2_icon_1)
        ||  (fourSlot == .game_2_icon_1 && fiveSlot == .game_2_icon_1) {
            self.winCount += 20
            Playing.run4()
        }
        else
        if (firstSlot == .game_2_icon_11 && secondSlot == .game_2_icon_11)
        ||  (thirdSlot == .game_2_icon_11 && fourSlot == .game_2_icon_11)
        ||  (secondSlot == .game_2_icon_11 && fourSlot == .game_2_icon_11)
        ||  (firstSlot == .game_2_icon_11 && thirdSlot == .game_2_icon_11)
        ||  (fourSlot == .game_2_icon_11 && fiveSlot == .game_2_icon_11) {
            self.winCount += 50
            Playing.run4()
        }
        else
        if (firstSlot == .game_2_icon_12 && secondSlot == .game_2_icon_12)
        ||  (thirdSlot == .game_2_icon_12 && fourSlot == .game_2_icon_12)
        ||  (secondSlot == .game_2_icon_12 && fourSlot == .game_2_icon_12)
        ||  (firstSlot == .game_2_icon_12 && thirdSlot == .game_2_icon_12)
        ||  (fourSlot == .game_2_icon_12 && fiveSlot == .game_2_icon_12) {
            self.winCount += 150
            Playing.run4()
        }
        else
        if (firstSlot == .game_2_icon_3 && secondSlot == .game_2_icon_3)
        ||  (thirdSlot == .game_2_icon_3 && fourSlot == .game_2_icon_3)
        ||  (secondSlot == .game_2_icon_3 && fourSlot == .game_2_icon_3)
        ||  (firstSlot == .game_2_icon_3 && thirdSlot == .game_2_icon_3)
        ||  (fourSlot == .game_2_icon_3 && fiveSlot == .game_2_icon_3) {
            self.winCount += 5
            Playing.run4()
        }
        else
        if (firstSlot == .game_2_icon_9 && secondSlot == .game_2_icon_9)
        ||  (thirdSlot == .game_2_icon_9 && fourSlot == .game_2_icon_9)
        ||  (secondSlot == .game_2_icon_9 && fourSlot == .game_2_icon_9)
        ||  (firstSlot == .game_2_icon_9 && thirdSlot == .game_2_icon_9)
        ||  (fourSlot == .game_2_icon_9 && fiveSlot == .game_2_icon_9) {
            self.winCount += 15
            Playing.run4()
        }
        else
        if (firstSlot == .game_2_icon_2 && secondSlot == .game_2_icon_2)
        ||  (thirdSlot == .game_2_icon_2 && fourSlot == .game_2_icon_2)
        ||  (secondSlot == .game_2_icon_2 && fourSlot == .game_2_icon_2)
        ||  (firstSlot == .game_2_icon_2 && thirdSlot == .game_2_icon_2)
        ||  (fourSlot == .game_2_icon_2 && fiveSlot == .game_2_icon_2) {
            self.coins -= 5
            if coins < 0 {
                self.coins = 0
                self.show = .lose
                Playing.run5()
            }
        }
        else
        if (firstSlot == .game_2_icon_7 && secondSlot == .game_2_icon_7)
        ||  (thirdSlot == .game_2_icon_7 && fourSlot == .game_2_icon_7)
        ||  (secondSlot == .game_2_icon_7 && fourSlot == .game_2_icon_7)
        ||  (firstSlot == .game_2_icon_7 && thirdSlot == .game_2_icon_7)
        ||  (fourSlot == .game_2_icon_7 && fiveSlot == .game_2_icon_7) {
            self.coins -= 20
            if coins < 0 {
                self.coins = 0
                self.show = .lose
                Playing.run5()
            }
        }
        else
        if (firstSlot == .game_2_icon_8 && secondSlot == .game_2_icon_8)
        ||  (thirdSlot == .game_2_icon_8 && fourSlot == .game_2_icon_8)
        ||  (secondSlot == .game_2_icon_8 && fourSlot == .game_2_icon_8)
        ||  (firstSlot == .game_2_icon_8 && thirdSlot == .game_2_icon_8)
        ||  (fourSlot == .game_2_icon_8 && fiveSlot == .game_2_icon_8) {
            self.coins -= 10
            if coins < 0 {
                self.coins = 0
                self.show = .lose
                Playing.run5()
            }
        }
        else {
            if allSelectedSlots == [.game_2_icon_5, .game_2_icon_5, .game_2_icon_5, .game_2_icon_5, .game_2_icon_5] {
                self.winCount += 500
                Playing.run4()
            }
            else
            if allSelectedSlots == [.game_2_icon_11, .game_2_icon_11, .game_2_icon_11, .game_2_icon_11, .game_2_icon_11] {
                self.winCount += 1500
                Playing.run4()
            }
            else
            if allSelectedSlots == [.game_2_icon_1, .game_2_icon_1, .game_2_icon_1, .game_2_icon_1, .game_2_icon_1] {
                self.winCount += 300
                Playing.run4()
            }
        }
    }
}
