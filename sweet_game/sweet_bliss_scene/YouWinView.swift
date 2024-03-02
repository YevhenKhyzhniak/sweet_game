//
//  YouWinView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 01.03.2024.
//

import SwiftUI

struct YouWinView: View {
    
    let nextLevel: () -> Void
    let mainMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(R.image.you_win.name)
                .padding()
            
            ButtonView(title: "NEXT LEVEL") {
                self.nextLevel()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            
            ButtonView(title: "MAIN MENU") {
                self.mainMenu()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
        }
        .padding()
        .background(Image(R.image.modal_window.name).resizable())
    }
}

struct YouLoseView: View {
    
    let tryAgain: () -> Void
    let mainMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(R.image.you_lose.name)
                .padding()
            
            ButtonView(title: "SHOP") {
                self.tryAgain()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            
            ButtonView(title: "MAIN MENU") {
                self.mainMenu()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
        }
        .padding()
        .background(Image(R.image.modal_window.name).resizable())
    }
}

struct PauseView: View {
    
    let unpause: () -> Void
    let mainMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("PAUSE").font(.title).bold().foregroundColor(.white)
            
            ButtonView(title: "UNPAUSE") {
                self.unpause()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            
            ButtonView(title: "MAIN MENU") {
                self.mainMenu()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
        }
        .padding()
        .background(Image(R.image.modal_window.name).resizable())
    }
}

struct ErrorMessage: View {
    
    let shop: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Oh, something's wrong").font(.title).bold().foregroundColor(.white)
            
            Text("Go to the store and buy extra lives to extend the game").foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            ButtonView(title: "GO TO SHOP") {
                self.shop()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            .padding(.vertical)
            
        }
        .padding()
        .background(Image(R.image.modal_window.name).resizable())
    }
}

struct SettingsView: View {
    
    @State private var sound: Bool = false {
        willSet {
            SweetGameLevelBusines.sound = newValue
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image(R.image.sound_on.name)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .opacity(self.sound ? 1.0 : 0.5)
                .onTapGesture {
                    self.sound.toggle()
                }
                .padding()
            
            ButtonView(title: "PRIVACY POLICY") {
                ///
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            
            ButtonView(title: "TERMS OF USE") {
                ///
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            
        }
        .padding()
        .background(Image(R.image.modal_window.name).resizable())
        .onAppear {
            self.sound = SweetGameLevelBusines.sound
        }
    }
}
