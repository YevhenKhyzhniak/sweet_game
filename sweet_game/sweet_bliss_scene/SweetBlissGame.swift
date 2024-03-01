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
    
    @Injected(\.router) private var router
    
    let level: SweetBlissGameLevel
    let heartRateIncrement = 20.0
    
    @State private var items: [GameItems] = []
    @State private var onStart: Bool = false
    
    @State private var heartRate: Double = SweetBlissGameLevelBusines.heartRate
    
    @ViewBuilder
    var body: some View {
        self.contentView()
            .onReceive(SweetBlissGameControl.catchGameItem) { item in
                self.items.append(item)
                
                if item == .bomb {
                    self.heartRate -= heartRateIncrement
                }
                
                self.checkWinLose()
                
            }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        if self.onStart {
            SweetBlissGameSpriteContentView(size: UIScreen.main.bounds.size)
                .overlay(
                    VStack {
                        HStack {
                            BackButtonView() {
                                self.router.presentFullScreen(.showSweetBlissLevels)
                            }
                            Spacer(minLength: 5)
                            BalanceRowView()
                            Spacer(minLength: 5)
                            PauseButtonView() {
                                SweetBlissGameControl.onStart.send(false)
                            }
                        }
                        self.betTopView()
                    }
                   .padding(.top, 60).padding(.horizontal, 8), alignment: .top
                )
                .overlay(
                    self.controlBasketButtonsView().padding(.bottom, 80), alignment: .bottom
                )
                .overlay(self.heartRateView().padding(30), alignment: .bottomLeading)
        } else {
            Image(R.image.app_background.name)
                .resizable()
                .ignoresSafeArea()
                .containerShape(Rectangle())
                .onTapGesture {
                    self.onStart.toggle()
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
        ProgressView(value: heartRate, total: 100.0)
            .tint(.purple)
            .padding()
            .frame(width: UIScreen.main.bounds.width / 3, height: 30)
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
    }
    
    @ViewBuilder
    private func makeRequiredCatchedItemsView() -> some View {
        switch Level(value: self.level.level) {
        case .low:
            HStack {
                Image(R.image.marshmallow.name)
                Text(String(format: "%d/%d", self.items.filter{$0 == .marshmallow}.count, 10)).font(.caption2).foregroundColor(.white)
            }
        case .normal:
            HStack {
                Image(R.image.marshmallow.name)
                Text(String(format: "%d/%d", self.items.filter{$0 == .marshmallow}.count, 10)).font(.caption2).foregroundColor(.white)
                
                Image(R.image.chupachups.name)
                Text(String(format: "%d/%d", self.items.filter{$0 == .chupachups}.count, 10)).font(.caption2).foregroundColor(.white)
            }
        case .hard:
            HStack {
                Image(R.image.marshmallow.name)
                Text(String(format: "%d/%d", self.items.filter{$0 == .marshmallow}.count, 10)).font(.caption2).foregroundColor(.white)
                
                Image(R.image.chupachups.name)
                Text(String(format: "%d/%d", self.items.filter{$0 == .chupachups}.count, 10)).font(.caption2).foregroundColor(.white)
                
                Image(R.image.candy_one.name)
                Text(String(format: "%d/%d", self.items.filter{$0 == .candyOne}.count, 10)).font(.caption2).foregroundColor(.white)
            }
        }
    }
    
    private func checkWinLose() {
        Task {
            
            guard self.heartRate > 0 else {
                return
            }
            
            let level = Level(value: self.level.level)
            switch level {
            case .low:
                if self.items.filter {$0 == .marshmallow}.count == 10 {
                    
                }
            case .normal:
                break
            case .hard:
                break
            }
            
        }
    }
}

struct SweetBlissGameSpriteContentView: View {
    
    let size: CGSize
    
    var scene: SKScene {
        let scene = SweetBlissGameSprite(size: size)
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
        self.gameItem = GameItems.allCases.randomElement()!
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
                //soundaOff()
                print("Catch The Object")
                if let item = self.gameItem {
                    SweetBlissGameControl.catchGameItem.send(item)
                }
            } else {
                print("DONT Catch The Object")
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
