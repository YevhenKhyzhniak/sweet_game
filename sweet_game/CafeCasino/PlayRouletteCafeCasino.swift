//
//  PlayRouletteCafeCasino.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 27.03.2024.
//

import SwiftUI
import Combine

struct PlayRouletteCafeCasino: View {
    
    enum GameType {
        case auto
        case manual
    }
    
    enum Show: Identifiable {
        case win(Int)
        
        var id: Int {
            switch self {
            case .win:
                return 1
            }
        }
    }
    
    @Injected(\.router) private var router
    
    @State private var show: Show? = nil
    
    @State private var coins: Double = 0 {
        willSet {
            GamesBusines.coins = newValue
        }
    }
    
    @State private var winCount: Double = 0.0
    
    // Timer
    
    @State private var manualSpinTimes = 10
    @State private var autoSpinTimes = 10
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    @State private var timerSubscription: AnyCancellable?
    @State private var timerActive = false
    
    @State private var angle: Double = 0
    
    
    var body: some View {
        ZStack {
            Image("game_4_background").resizable().scaleEffect(1.2)
            self.contentView()
                .blur(radius: self.show != nil ? 5.0 : 0.0)
        }
        .onAppear {
            self.coins = GamesBusines.coins
        }
        .onDisappear {
            self.timerSubscription?.cancel()
            self.coins += self.winCount
        }
        .simpleToast(item: self.$show, options: .init(alignment: .center, edgesIgnoringSafeArea: .all)) {
            switch self.show {
            case let .win(value):
                VStack(spacing: 15) {
                    Text("YOU WIN!!!").bold().foregroundColor(.black)
                    
                    Text(String(format: "TOTAL WIN: %.2f", self.winCount)).bold().foregroundColor(.black)
                    
                    Button {
                        self.show = nil
                        self.coins += self.winCount
                        self.router.presentFullScreen(.showMain)
                    } label: {
                        Text("TAKE REWARD&CLOSE")
                            .foregroundColor(.white)
                            .padding()
                            .background(Image("game_4_large_button").resizable())
                    }
                }
                .padding()
                .background(Image("game_4_win_back").resizable())
                .padding()
                .padding()
            default:
                EmptyView()
            }
        }
    }
    
    private func contentView() -> some View {
        VStack {
            
            HStack {
                Button {
                    self.router.presentFullScreen(.showMain)
                } label: {
                    Image("game_4_back_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                }
                .padding(.trailing)
                
                self.balanceRow()
                
                Spacer(minLength: 1)
            }
            
            HStack {
                self.spintsView()
                self.rouletteView().scaleEffect(1.2)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private func balanceRow() -> some View {
        HStack(spacing: 20) {
            
            Text(String(format: "BALANCE: %.2f", self.coins)).bold().padding().font(.footnote).foregroundColor(.black)
                .background(
                    Image("game_4_label_back").resizable().frame(height: 40)
                )
            
            Text(String(format: "TOTAL WIN: %.2f", self.winCount)).bold().padding().font(.footnote).foregroundColor(.black)
                .background(
                    Image("game_4_label_back").resizable().frame(height: 40)
                )
        }
    }
    
    private func spintsView() -> some View {
        HStack (spacing: 15) {
            
            VStack(spacing: 15) {
                Text("AUTOSPIN").bold().foregroundColor(.white)
                
                Text(String(format: "TIMES: %d", self.autoSpinTimes)).bold().padding(.horizontal).font(.footnote).foregroundColor(.black)
                    .background(
                        Image("game_4_label_back").resizable().frame(height: 30)
                    )
                
                HStack {
                    Button {
                        if self.autoSpinTimes > 1 {
                            self.autoSpinTimes -= 1
                        }
                    } label: {
                        Image("game_4_small_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .overlay(Text("-").bold().foregroundColor(.white))
                    }

                    Button {
                        if self.autoSpinTimes < 20 {
                            self.autoSpinTimes += 1
                        }
                    } label: {
                        Image("game_4_small_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .overlay(Text("+").bold().foregroundColor(.white))
                    }
                    
                }
                
                Button {
                    
                    if self.timerActive == false {
                        self.timerActive = true
                        timerSubscription = Timer.publish(every: 3.5, on: .main, in: .common)
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
                    Image("game_4_large_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .overlay(Text(self.timerActive ? "DISABLE" : "ENABLE").bold().foregroundColor(.white))
                }
                
            }
            
            VStack(spacing: 15) {
                Text("YOUR BET")
                    .bold()
                    .foregroundColor(.white)
                
                Text(String(format: "TIMES: %d", self.manualSpinTimes)).bold().padding(.horizontal).font(.footnote).foregroundColor(.black)
                    .background(
                        Image("game_4_label_back").resizable().frame(height: 30)
                    )
                
                HStack {
                    Button {
                        if self.manualSpinTimes > 1 {
                            self.manualSpinTimes -= 1
                        }
                    } label: {
                        Image("game_4_small_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .overlay(Text("-").bold().foregroundColor(.white))
                    }

                    Button {
                        if self.manualSpinTimes < 20 {
                            self.manualSpinTimes += 1
                        }
                    } label: {
                        Image("game_4_small_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .overlay(Text("+").bold().foregroundColor(.white))
                    }
                    
                }
                
                Button {
                    self.spinSlots(.manual)
                    if self.manualSpinTimes > 0 {
                        self.manualSpinTimes -= 1
                    }
                } label: {
                    Image("game_4_large_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .overlay(Text("SPIN").bold().foregroundColor(.white))
                }
                .disabled(self.timerActive)
                .opacity(self.timerActive ? 0.5 : 1.0)
            }
        }
        .padding()
    }
    
    
    private func rouletteView() -> some View {
        ZStack {
            Image("game_4_roulette")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                .rotationEffect(.degrees(angle))
            Image("game_4_roulette_pin")
                .resizable()
                .scaledToFit()
        }
    }
    
    func spinSlots(_ type: GameType) {
        
        if type == .manual && self.manualSpinTimes == 0 {
            if winCount > 0 {
                self.show = .win(Int(winCount))
            }
            return
        }
        if type == .auto && self.autoSpinTimes == 0 {
            if winCount > 0 {
                self.show = .win(Int(winCount))
            }
            return
        }
        withAnimation(.linear(duration: 2)) {
            angle += Double.random(in: 720...1440) // Мінімум 2 оберта, максимум 4
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            calculateBonus()
        }
    }
    
    func calculateBonus() {
        let finalAngle = angle.truncatingRemainder(dividingBy: 360)
        let selectedId = Int((finalAngle / 28.5).rounded()) % 12
        
        print(selectedId)
        
        switch selectedId {
        case 0:
            self.winCount = winCount == 0 ? 5.0 : winCount * 5.0
        case 1:
            self.winCount = winCount == 0 ? 2.3 : winCount * 2.3
        case 2:
            self.winCount = winCount == 0 ? 1.5 : winCount * 1.5
        case 3:
            self.winCount = winCount == 0 ? 3.0 : winCount * 3.0
        case 4:
            self.winCount = 0
        case 5:
            self.winCount = winCount == 0 ? 1.1 : winCount * 1.1
        case 6:
            self.winCount = winCount == 0 ? 10.0 : winCount * 10.0
        case 7:
            break
        case 8:
            self.winCount = winCount == 0 ? 5.0 : winCount * 5.0
        case 9:
            self.winCount = winCount == 0 ? 1.1 : winCount * 1.1
        case 10:
            self.winCount = 0
        case 11:
            self.winCount = winCount == 0 ? 1.5 : winCount * 1.5
        default:
            break
            
        }
    }
}
