//
//  SettingsCafeCasino.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 27.03.2024.
//

import SwiftUI

struct SettingsCafeCasino: View {
    
    @State private var isSelectSound: Bool = false {
        willSet {
            GamesBusines.sound = newValue
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Settings").bold().foregroundColor(.black)
                .padding(.top, 25)
            
            HStack(spacing: 15) {
                Spacer(minLength: 1)
                
                Text("Sound").foregroundColor(.black)
                
                Button(action: {
                    self.isSelectSound.toggle()
                }) {
                    Capsule(style: .circular)
                        .fill(Color(.blue).opacity(0.5))
                        .frame(width: 52, height: 25)
                        .overlay(
                            Circle()
                              .fill(Color(.purple))
                              .shadow(radius: 1, x: 0, y: 1)
                              .padding(1.5)
                              .offset(x: self.isSelectSound ? 15 : -15)
                        )
                }
                
                Spacer(minLength: 1)
            }
            .padding()
            
            Button {
                if let url = URL(string: "https://tiget-city3indi.city/gamepolicy3.html") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            } label: {
                Text("PRIVACY POLICY")
                    .bold()
                    .frame(width: 150)
                    .padding()
                    .foregroundColor(.white)
                    .background(Image("empty_button").resizable())
            }

            Button {
                if let url = URL(string: "https://tiget-city3indi.city/gamepolicy3.html") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            } label: {
                Text("TERMS OF USE")
                    .bold()
                    .frame(width: 150)
                    .padding()
                    .foregroundColor(.white)
                    .background(Image("empty_button").resizable())
            }
            .padding(.bottom, 25)
            
        }
        .padding()
        .background(Image("settings_background").resizable().frame(width: 300))
        .frame(width: 300)
        .onAppear {
            self.isSelectSound = GamesBusines.sound
        }
    }
}
