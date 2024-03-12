//
//  YouWinView.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 01.03.2024.
//

import SwiftUI

struct YouWinView: View {
    
    let win: Int
    let ok: () -> Void
    let mainMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("You win!")
                .bold()
                .foregroundColor(.white)
                .font(.title)
                .padding(.top)
            
            Image("balance_row")
                .resizable()
                .frame(width: 80, height: 30)
                .overlay(
                    HStack {
                        Image("coins")
                        Text("\(win)").foregroundColor(.white)
                    }
                )
            
            ButtonView(title: "OK") {
                self.ok()
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
        .background(Image("dialog_bg").resizable())
    }
}

struct YouLoseView: View {
    
    let tryAgain: () -> Void
    let mainMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Oops.... You don't have enough coins!")
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(.top)
            
            ButtonView(title: "CLOSE") {
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
        .background(Image("dialog_bg").resizable())
    }
}

struct TryAgainView: View {
    
    let tryAgain: () -> Void
    let mainMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Game over!!!")
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(.top)
            
            ButtonView(title: "TRY AGAIN") {
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
        .background(Image("dialog_bg").resizable())
    }
}

struct PauseView: View {
    
    let unpause: () -> Void
    let mainMenu: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Paused").font(.title).bold().foregroundColor(.white)
            
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
        .background(Image("dialog_bg").resizable())
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
        .background(Image("modal_window").resizable())
    }
}

struct SettingsView: View {
    
    @Injected(\.router) private var router
    
    @State private var sound: Bool = false {
        willSet {
            GamesBusines.sound = newValue
        }
    }
    
    @State private var vibro: Bool = false {
        willSet {
            GamesBusines.vibro = newValue
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack(spacing: 20) {
                BackButtonView() {
                    self.router.presentFullScreen(.showMain)
                }
                Spacer(minLength: 5)
                TopView(title: "Settings")
                    .padding(.trailing, 40)
                Spacer(minLength: 5)
            }
            .padding(.horizontal, 20)
            
            HStack {
                Text("Sound").foregroundColor(.white).bold()
                Spacer(minLength: 5)
                ToggleProcessView(isSelect: sound, inProcess: false, type: .toggle) { state in
                    self.sound = state
                }
            }.padding(.horizontal, 20)
            
            HStack {
                Text("Vibro").foregroundColor(.white).bold()
                Spacer(minLength: 5)
                ToggleProcessView(isSelect: vibro, inProcess: false, type: .toggle) { state in
                    self.vibro = state
                }
            }.padding(.horizontal, 20)
            
            ButtonView(title: "PRIVACY POLICY") {
                if let url = URL(string: "https://www.sweet1bonanaza-bliss.live/topolicyapp.html") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            
            ButtonView(title: "TERMS OF USE") {
                if let url = URL(string: "https://www.sweet1bonanaza-bliss.live/thetermss.html") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            
            Spacer(minLength: 1)
            
        }
        .background(Image("app_background").resizable().scaleEffect(1.2))
        .onAppear {
            self.sound = GamesBusines.sound
            self.vibro = GamesBusines.vibro
        }
    }
}


struct CombinationView: View {
    
    let close: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Combinations").bold().font(.title).foregroundColor(.white)
                .padding()
            
            HStack(spacing: 20) {
                VStack {
                    HStack {
                        Image("dinamite").resizable().frame(width: 40, height: 40)
                        Text("= X2 \nyour bet").foregroundColor(.white)
                    }
                    
                    HStack {
                        Image("bag").resizable().frame(width: 40, height: 40)
                        Text("= X3 \nyour bet").foregroundColor(.white)
                    }
                    
                    HStack {
                        Image("dragon").resizable().frame(width: 40, height: 40)
                        Text("= X4 \nyour bet").foregroundColor(.white)
                    }
                }
                
                VStack {
                    HStack {
                        Image("gold").resizable().frame(width: 40, height: 40)
                        Text("= X5 \nyour bet").foregroundColor(.white)
                    }
                    
                    HStack {
                        Image("jandj").resizable().frame(width: 40, height: 40)
                        Text("= X6 \nyour bet").foregroundColor(.white)
                    }
                    
                    HStack {
                        Image("globe").resizable().frame(width: 40, height: 40)
                        Text("= X7 \nyour bet").foregroundColor(.white)
                    }
                }
            }
            
            ButtonView(title: "CLOSE") {
                self.close()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
        }
        .padding()
        .background(Image("dialog_bg").resizable())
    }
}
