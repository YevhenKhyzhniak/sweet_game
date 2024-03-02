//
//  SweetBlissGame.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 28.02.2024.
//

import SwiftUI
import SpriteKit
import GameplayKit
import AVFoundation
import Combine

struct SweetBlissGameControl {
    static let moveTo: PassthroughSubject<SweetBlissGame.BasketMove, Never> = .init()
    static let onStart: PassthroughSubject<Bool, Never> = .init()
    static let catchGameItem: PassthroughSubject<GameItems, Never> = .init()
}

struct SweetBlissGame: View {
    
    enum GameResult: Int, Identifiable {
        case win = 0
        case lose = 1
        case pause = 2
        
        var id: Int {
            return self.rawValue
        }
    }
    
    @Injected(\.router) private var router
    
    let level: SweetBlissGameLevel
    let heartRateIncrement = 25.0
    
    @State private var items: [GameItems] = []
    @State private var onStart: Bool = false
    @State private var gameResult: GameResult? = nil
    
    @State private var heartRate: Double = 0.0 {
        willSet {
            SweetGameLevelBusines.heartRate = newValue
        }
    }
    @State private var candies: Int = 0 {
        willSet {
            SweetGameLevelBusines.candies = newValue
        }
    }
    
    @ViewBuilder
    var body: some View {
        self.contentView()
            .onReceive(SweetBlissGameControl.catchGameItem) { item in
                guard self.heartRate > 0 else {
                    DispatchQueue.main.async {
                        SweetBlissGameControl.onStart.send(false)
                        self.gameResult = .lose
                    }
                    return
                }
                
                self.items.append(item)
                
                if item == .bomb || item == .сaterpillar {
                    self.heartRate -= heartRateIncrement
                }
                
                self.checkWinLose(item)
                
            }
            .onAppear {
                self.heartRate = SweetGameLevelBusines.heartRate
                self.candies = SweetGameLevelBusines.candies
            }
            .onDisappear {
                SweetBlissGameControl.onStart.send(false)
            }
            .simpleToast(item: self.$gameResult, options: .init(alignment: .center, dismissOnTap: false, edgesIgnoringSafeArea: .all)) {
                switch self.gameResult {
                case .win:
                    YouWinView {
                        SweetGameLevelBusines.unlockNextLevel(current: self.level)
                        self.router.presentFullScreen(.showSweetBlissLevels)
                    } mainMenu: {
                        self.router.presentFullScreen(.showMain)
                    }
                    .padding()
                case .lose:
                    YouLoseView {
                        self.router.presentFullScreen(.showShop)
                    } mainMenu: {
                        self.router.presentFullScreen(.showMain)
                    }
                    .padding()
                case .pause:
                    PauseView {
                        self.gameResult = nil
                        SweetBlissGameControl.onStart.send(true)
                    } mainMenu: {
                        self.router.presentFullScreen(.showMain)
                    }
                    .padding()
                default:
                    EmptyView()
                }
            }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        if self.onStart {
            SweetBlissGameSpriteContentView(size: UIScreen.main.bounds.size, level: Level(value: self.level.level))
                .overlay(
                    VStack {
                        HStack {
                            BackButtonView() {
                                self.router.presentFullScreen(.showSweetBlissLevels)
                            }
                            Spacer(minLength: 5)
                            BalanceRowView(balance: self.candies)
                            Spacer(minLength: 5)
                            PauseButtonView() {
                                self.onPauseMethod()
                            }
                        }
                        self.betTopView()
                    }
                   .padding(.top, 40).padding(.horizontal, 8), alignment: .top
                )
                .overlay(
                    self.controlBasketButtonsView().padding(.bottom, 80), alignment: .bottom
                )
                .overlay(self.heartRateView().padding(30), alignment: .bottomLeading)
                .blur(radius: self.gameResult != nil ? 1.0 : 0.0)
                .disabled(self.gameResult != nil)
        } else {
            Image(R.image.app_background.name)
                .resizable()
                .ignoresSafeArea()
                .overlay(HStack {
                    Text("Click to the game").foregroundColor(.white)
                    Image(R.image.click_to_the_game.name)
                }.padding())
                .containerShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        self.onStart.toggle()
                    }
                }
        }
    }
    
    private func basketView() -> some View {
        Image(R.image.bliss_game_busket.name)
    }
    
    private func controlBasketButtonsView() -> some View {
        HStack {
            self.leftArrowView()
            Spacer(minLength: 0)
            self.rightArrowView()
        }
    }
    
    private func heartRateView() -> some View {
        HStack(spacing: 0) {
            Image(R.image.heart.name).resizable().frame(width: 30, height: 30)
            Image(R.image.heart_rate.name)
                .resizable()
                .overlay(
                    ProgressView(value: heartRate, total: 100.0)
                        .tint(.purple)
                        .padding(.leading, 5)
                        .padding(.trailing, 3)
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                )
                .frame(width: UIScreen.main.bounds.width / 3, height: 15)
        }
    }
    
    private func leftArrowView() -> some View {
        Button(action: {
            withAnimation {
                SweetBlissGameControl.moveTo.send(.leading)
            }
        }, label: {
            Image(R.image.left_arrow.name)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .padding(.leading, 10)
        })
    }
    
    private func rightArrowView() -> some View {
        Button(action: {
            withAnimation {
                SweetBlissGameControl.moveTo.send(.trailing)
            }
        }, label: {
            Image(R.image.right_arrow.name)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .padding(.trailing, 10)
        })
    }
    
    private func betTopView() -> some View {
        Image(R.image.bet_top.name)
            .resizable()
            .frame(height: 65)
            .overlay(
                self.makeRequiredCatchedItemsView()
            )
    }
}

extension SweetBlissGame {
    
    enum BasketMove {
        case leading
        case trailing
    }
    
    enum Level {
        case low
        case normal
        case hard
        
        init(value: Int) {
            switch value {
            case 1...10:
                self = .low
            case 11...20:
                self = .normal
            case 21...30:
                self = .hard
            default:
                self = .low
            }
        }
        
        func makeRandomItems() -> [GameItems] {
            var result = GameItems.allCases
            switch self {
            case .low:
                result.append(contentsOf: Array(repeating: .marshmallow, count: 6))
                return result
            case .normal:
                result.append(contentsOf: Array(repeating: .marshmallow, count: 3))
                result.append(contentsOf: Array(repeating: .chupachups, count: 3))
                return result
            case .hard:
                result.append(contentsOf: Array(repeating: .marshmallow, count: 3))
                result.append(contentsOf: Array(repeating: .chupachups, count: 3))
                result.append(contentsOf: Array(repeating: .candyOne, count: 3))
                return result
            }
        }
    }
    
    @ViewBuilder
    private func makeRequiredCatchedItemsView() -> some View {
        switch Level(value: self.level.level) {
        case .low:
            HStack {
                Image(R.image.marshmallow.name).resizable().scaledToFit().frame(width: 30, height: 30)
                Text(String(format: "%d/%d", self.items.filter{$0 == .marshmallow}.count, 10)).font(.caption2).foregroundColor(.white)
            }
        case .normal:
            HStack {
                Image(R.image.marshmallow.name).resizable().scaledToFit().frame(width: 30, height: 30)
                Text(String(format: "%d/%d", self.items.filter{$0 == .marshmallow}.count, 10)).font(.caption2).foregroundColor(.white)
                
                Image(R.image.chupachups.name).resizable().scaledToFit()
                Text(String(format: "%d/%d", self.items.filter{$0 == .chupachups}.count, 10)).font(.caption2).foregroundColor(.white)
            }
        case .hard:
            HStack {
                Image(R.image.marshmallow.name).resizable().scaledToFit().frame(width: 30, height: 30)
                Text(String(format: "%d/%d", self.items.filter{$0 == .marshmallow}.count, 10)).font(.caption2).foregroundColor(.white)
                
                Image(R.image.chupachups.name).resizable().scaledToFit().frame(width: 30, height: 30)
                Text(String(format: "%d/%d", self.items.filter{$0 == .chupachups}.count, 10)).font(.caption2).foregroundColor(.white)
                
                Image(R.image.candy_one.name).resizable().scaledToFit().frame(width: 30, height: 30)
                Text(String(format: "%d/%d", self.items.filter{$0 == .candyOne}.count, 10)).font(.caption2).foregroundColor(.white)
            }
        }
    }
    
    private func checkWinLose(_ newItem: GameItems) {
        let level = Level(value: self.level.level)
        switch level {
        case .low:
            if newItem == .marshmallow {
                self.candies += 10
            }
            if self.items.filter({$0 == .marshmallow}).count >= 10 {
                DispatchQueue.main.async {
                    SweetBlissGameControl.onStart.send(false)
                    self.gameResult = .win
                }
            }
        case .normal:
            if [.marshmallow, .chupachups].contains(where: {$0 == newItem}){
                self.candies += 10
            }
            if self.items.filter({$0 == .marshmallow}).count >= 10
            && self.items.filter({$0 == .chupachups}).count >= 10 {
                DispatchQueue.main.async {
                    SweetBlissGameControl.onStart.send(false)
                    self.gameResult = .win
                }
            }
        case .hard:
            if [.marshmallow, .chupachups, .candyOne].contains(where: {$0 == newItem}) {
                self.candies += 10
            }
            if self.items.filter({$0 == .marshmallow}).count >= 10
            && self.items.filter({$0 == .chupachups}).count >= 10
            && self.items.filter({$0 == .candyOne}).count >= 10 {
                DispatchQueue.main.async { 
                    SweetBlissGameControl.onStart.send(false)
                    self.gameResult = .win
                }
            }
        }
    }
    
    private func onPauseMethod() {
        SweetBlissGameControl.onStart.send(false)
        self.gameResult = .pause
    }
}

struct SweetBlissGameSpriteContentView: View {
    
    let size: CGSize
    let level: SweetBlissGame.Level
    
    var scene: SKScene {
        let scene = SweetBlissGameSprite(size: size)
        scene.level = self.level
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .frame(width: size.width, height: size.height)
            .ignoresSafeArea()
    }
}


class SweetBlissGameSprite: SKScene, SKPhysicsContactDelegate {
    
    var cancellable: Set<AnyCancellable> = []
    
    override init(size: CGSize) {
        super.init(size: size)
        
        SweetBlissGameControl.moveTo.sink { [weak self] state in
            self?.moveBasketTo(state: state)
        }
        .store(in: &cancellable)
        
        SweetBlissGameControl.onStart.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case true:
                self.dropBall()
            case false:
                self.deleteBalls()
            }
        }
        .store(in: &cancellable)
    }
    
    deinit {
        self.cancellable = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var basket: SKSpriteNode!
    var gameItem: GameItems?
    var level: SweetBlissGame.Level!
    
    override func didMove(to view: SKView) {
        self.onStart()
        self.applyGravity()
        self.dropBall()
    }
    
    func moveBasketTo(position: CGPoint) {
        basket.position = position
    }
    
    func moveBasketTo(state: SweetBlissGame.BasketMove) {
        switch state {
        case .leading:
            withAnimation {
                if self.basket.position.x > UIScreen.main.bounds.width / 4 {
                    self.basket.position = .init(x: self.basket.position.x - (UIScreen.main.bounds.width / 6), y: self.basket.position.y)
                }
            }

        case .trailing:
            withAnimation {
                if self.basket.position.x < UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 6)  {
                    self.basket.position = .init(x: self.basket.position.x + (UIScreen.main.bounds.width / 6), y: self.basket.position.y)
                }
            }
        }
    }
    
    func onStart() {
        self.size = view!.bounds.size
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsWorld.contactDelegate = self
        self.name = "backLines"
        
        let background = SKSpriteNode(imageNamed: R.image.app_background.name)
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.blendMode = .replace
        background.zPosition = -8
        addChild(background)
        
        //R.image.backing.name
        
        let rectangle = SKShapeNode(rectOf: CGSize(width: frame.width, height: 1))
        rectangle.fillColor = .white
        rectangle.position = CGPoint(x: frame.width/2, y: 2)
        rectangle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: 4))
        rectangle.physicsBody?.isDynamic = false
        rectangle.name = "bottomi"
        addChild(rectangle)
        
        self.createBasket()
    }
    
    func createBasket() {
        
        let background = SKSpriteNode(imageNamed: R.image.backing.name)
        background.position = CGPoint(x: frame.width/2, y: 0)
        background.size = CGSize(width: frame.width - 50, height: frame.height / 3)
        background.blendMode = .alpha
        background.zPosition = -8
        addChild(background)
        
        basket = SKSpriteNode(imageNamed: R.image.bliss_game_busket.name)
        basket.position =  CGPoint(x: UIScreen.main.bounds.width / 2, y: 100)
        basket.size = CGSize(width: UIScreen.main.bounds.width / 3 , height: 80)
        basket.physicsBody = SKPhysicsBody(rectangleOf: basket.size)
        basket.physicsBody?.isDynamic = false
        basket.name = "basket"
        addChild(basket)
    }
    
    func applyGravity() {
        let gravity = -3.0 // m/s^2
        physicsWorld.gravity = CGVector(dx: 0, dy: gravity)
    }
    
    func dropBall() {
        self.gameItem = self.level.makeRandomItems().randomElement()!
        let topppi : CGFloat = frame.height - frame.height * 0.12
        let randomX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        let ball = SKSpriteNode(imageNamed: self.gameItem?.image ?? R.image.bomb.name)
        ball.position = CGPoint(x: randomX, y: topppi)
        ball.size = CGSize(width: 50, height: 50)
        addChild(ball)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.5
        ball.name = self.gameItem?.rawValue ?? "ball"
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
    }
    
 
    func deleteBalls() {
        let name = self.gameItem?.rawValue ?? "ball"
        for i in children {
            if i.name == name{
                i.removeFromParent()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        let name = self.gameItem?.rawValue ?? "ball"
        
        if nodeA.name == name  {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == name {
            collision(between: nodeB, object: nodeA)
        }
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "bottomi" {
            destroy(ball)
            self.dropBall()
        } else {
            if object.name == "basket" {
                PlaySound.run()
                if let item = self.gameItem {
                    SweetBlissGameControl.catchGameItem.send(item)
                }
            }
            destroy(ball)
            self.dropBall()
        }
    }
    
    func destroy(_ balll: SKNode) {
        balll.removeFromParent()
    }
    
}


#Preview {
    SweetBlissGame(level: .init(level: 1))
}
