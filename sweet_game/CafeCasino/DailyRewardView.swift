//
//  DailyRewardView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.03.2024.
//

import SwiftUI
import Combine

struct DailyRewardView: View {
    
    @State private var targetDate: Date
    @State private var timeLeft = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        // Спроба відновлення збереженої цільової дати
        if let savedDate = UserDefaults.standard.object(forKey: "targetDate") as? Date {
            _targetDate = State(initialValue: savedDate)
        } else {
            // Встановлення нової цільової дати на 24 години вперед, якщо збережена дата відсутня
            let newTargetDate = Date().addingTimeInterval(24 * 60 * 60)
            _targetDate = State(initialValue: newTargetDate)
            UserDefaults.standard.set(newTargetDate, forKey: "targetDate")
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image("chest_of_coins").resizable().frame(width: 120, height: 120).padding(.leading)
            
            VStack(spacing: 20) {
                
                Text("DAILY REWARD").bold().font(.title3).foregroundColor(.black)
                    .padding(.top, 25)
                
                Text("Open your Daily reward box\n every 24 hours\n and get free coins!")
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Button {
                    if self.timeLeft == "GET REWARD" {
                        GamesBusines.coins += 500
                    }
                } label: {
                    Text(timeLeft)
                        .bold()
                        .frame(width: 150)
                        .padding()
                        .foregroundColor(.white)
                        .background(Image("empty_button").resizable())
                }
                .opacity(self.timeLeft == "GET REWARD" ? 1.0 : 0.5)
                .padding(.bottom, 25)
            }
            .padding(.trailing)
        }
        .padding()
        .background(Image("settings_background").resizable())
        .onReceive(timer) { _ in
            updateTimeLeft()
        }
        .onAppear {
            updateTimeLeft()
        }
    }
    
    func updateTimeLeft() {
        let currentTime = Date()
        let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: currentTime, to: targetDate)
        
        // Форматування тексту відліку
        if let hour = difference.hour, let minute = difference.minute, let second = difference.second {
            timeLeft = String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        
        // Якщо відлік завершено
        if currentTime >= targetDate {
            timeLeft = "GET REWARD"
            timer.upstream.connect().cancel()
            // Видалення збереженої цільової дати, коли відлік завершено
            UserDefaults.standard.removeObject(forKey: "targetDate")
        }
    }
}
