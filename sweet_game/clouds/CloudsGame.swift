//
//  CloudsGame.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 11.03.2024.
//

import SwiftUI
import SpriteKit
import GameplayKit
import AVFoundation
import Combine

struct CloudsGame: View {
    
    enum Show: Identifiable {
        case lose
        case pause
        
        var id: Int {
            switch self {
            case .lose:
                return 1
            case .pause:
                return 2
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
    
    let skin: String
    
    var body: some View {
        CloudsGameContentView(size: UIScreen.main.bounds.size, tigerSkin: skin)
            .overlay(
                HStack(spacing: 20) {
                    BackButtonView() {
                        DispatchQueue.main.async {
                            AdventureGameControl.onStart.send(false)
                        }
                        self.router.presentFullScreen(.showMain)
                    }
                    Spacer(minLength: 1)
                    BalanceRowView(balance: self.coins)
                        .padding(.leading, 40)
                    
                    Button {
                        self.show = .pause
                        AdventureGameControl.onStart.send(false)
                    } label: {
                        Image("pause_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 20).padding(.top, 40), alignment: .top
            )
            .blur(radius: self.show != nil ? 5.0 : 0.0)
            .onAppear {
                self.coins = GamesBusines.coins
            }
            .onReceive(AdventureGameControl.catchCoints) { result in
                DispatchQueue.main.async {
                    self.coins += result
                }
            }
            .onReceive(AdventureGameControl.gameDidFinished) { result in
                DispatchQueue.main.async {
                    self.show = .lose
                }
            }
        
            .simpleToast(item: self.$show, options: .init(alignment: .center, edgesIgnoringSafeArea: .all)) {
                switch self.show {
                case .pause:
                    PauseView(unpause: {
                        DispatchQueue.main.async {
                            self.show = nil
                            AdventureGameControl.onStart.send(true)
                        }
                    }, mainMenu: {
                        DispatchQueue.main.async {
                            AdventureGameControl.onStart.send(false)
                        }
                        self.router.presentFullScreen(.showMain)
                    })
                    .padding()
                case .lose:
                    TryAgainView {
                        DispatchQueue.main.async {
                            self.show = nil
                            AdventureGameControl.onStart.send(true)
                        }
                    } mainMenu: {
                        DispatchQueue.main.async {
                            AdventureGameControl.onStart.send(false)
                        }
                        self.router.presentFullScreen(.showMain)
                    }
                    .padding()
                default:
                    EmptyView()
                }
            }
    }
}

struct CloudsGameContentView: View {
    
    let size: CGSize
    let tigerSkin: String
    
    var scene: SKScene {
        let scene = CloudsGameSprite(size: size)
        scene.tigerSkin = tigerSkin
        scene.scaleMode = .aspectFit
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .frame(width: size.width, height: size.height)
            .ignoresSafeArea()
    }
}


class CloudsGameSprite: SKScene, SKPhysicsContactDelegate {
    
    var cancellable: Set<AnyCancellable> = []
    
    override init(size: CGSize) {
        super.init(size: size)
        
        AdventureGameControl.onStart.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case true:
                self.gameStart()
            case false:
                self.gameOver()
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
    
    var tigerSkin: String? = nil
    
    var tiger : SKSpriteNode?
    var ground: SKSpriteNode!
    var bombTimer:Timer?
    var ceil : SKSpriteNode?
    
    let coinManCategory : UInt32 = 0x1 << 1
    let coinCategory : UInt32 = 0x1 << 2
    let bombCategory : UInt32 = 0x1 << 3
    let groundAndCeilCategory : UInt32 = 0x1 << 4
    
    override func didMove(to view: SKView) {
        self.applyGravity()
        self.initial()
        self.gameStart()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let tiger else { return }
        
        let touchLocation = touch.location(in: self)
        let tigerX = tiger.position.x
        
        // Обчислення різниці між дотиком і позицією гравця по X
        let deltaX = touchLocation.x - tigerX
        
        // Застосування стрибка залежно від різниці по X
        if deltaX < -50 {
            // Стрибок ліворуч
            tiger.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 100))
        } else if deltaX > 50 {
            // Стрибок праворуч
            tiger.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 100))
        } else {
            // Стрибок просто вгору
            tiger.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        }
        
    }
    
    func initial() {
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "adventure_bg")
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.blendMode = .replace
        background.zPosition = -8
        addChild(background)
        
        // Create ground sprite
        ground = SKSpriteNode(color: .clear, size: CGSize(width: size.width * 2, height: 50))
        ground.position = CGPoint(x: 0, y: 50)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundAndCeilCategory
        ground.physicsBody?.collisionBitMask = coinManCategory
        
        let leftSide = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: UIScreen.main.bounds.height * 2))
        leftSide.position = CGPoint(x: 0, y: 0)
        leftSide.physicsBody = SKPhysicsBody(rectangleOf: leftSide.size)
        leftSide.physicsBody?.isDynamic = false
        leftSide.physicsBody?.categoryBitMask = groundAndCeilCategory
        leftSide.physicsBody?.collisionBitMask = coinManCategory
        
        let rightSide = SKSpriteNode(color: .clear, size: CGSize(width: 1, height: UIScreen.main.bounds.height * 2))
        rightSide.position = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        rightSide.physicsBody = SKPhysicsBody(rectangleOf: rightSide.size)
        rightSide.physicsBody?.isDynamic = false
        rightSide.physicsBody?.categoryBitMask = groundAndCeilCategory
        rightSide.physicsBody?.collisionBitMask = coinManCategory
        
        addChild(ground)
        addChild(leftSide)
        addChild(rightSide)
    }
    
    func applyGravity() {
        let gravity = -5.0 // m/s^2
        physicsWorld.gravity = CGVector(dx: 0, dy: gravity)
    }
    
    func createPlate() {
        let plateName = ["cloud_stone_1", "cloud_stone_2"].randomElement()!
        let plate = SKSpriteNode(imageNamed: plateName)
        plate.physicsBody = SKPhysicsBody(rectangleOf: plate.size)
        plate.physicsBody?.affectedByGravity = false
        plate.physicsBody?.collisionBitMask = 0
        plate.physicsBody?.mass = 0.2
        plate.size = CGSize(width: plateName == "cloud_stone_1" ? 120 : 60, height: 35)
        addChild(plate)
        
        let addCoints = [true, true, false].randomElement()!
        let coin = SKSpriteNode(imageNamed: "coins")
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = coinManCategory
        coin.physicsBody?.collisionBitMask = 0
        coin.size = CGSize(width: 35, height: 35)
        coin.physicsBody?.mass = 0.05
        if addCoints {
            addChild(coin)
        }
        
        let randomX = [30, 60, 100, UIScreen.main.bounds.width - 60, UIScreen.main.bounds.width - 30].randomElement()!
        
        plate.position = CGPoint(x: randomX, y: UIScreen.main.bounds.height)
        coin.position = CGPoint(x: randomX, y: UIScreen.main.bounds.height + 40)
        
        let deadLine = SKSpriteNode(color: .clear, size: CGSize(width: plate.frame.width / 3, height: 1))
        deadLine.position = CGPoint(x: randomX, y: UIScreen.main.bounds.height - 20)
        deadLine.physicsBody = SKPhysicsBody(rectangleOf: deadLine.size)
        deadLine.physicsBody?.isDynamic = false
        deadLine.physicsBody?.categoryBitMask = bombCategory
        deadLine.physicsBody?.collisionBitMask = coinManCategory
        addChild(deadLine)
        
        let moveBottom = SKAction.moveBy(x: 0, y: -UIScreen.main.bounds.height, duration: 15)
        
        plate.run(SKAction.sequence([moveBottom, SKAction.removeFromParent()]))
        coin.run(SKAction.sequence([moveBottom, SKAction.removeFromParent()]))
        deadLine.run(SKAction.sequence([moveBottom, SKAction.removeFromParent()]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == coinCategory {
            contact.bodyA.node?.removeFromParent()
            DispatchQueue.main.async {
                AdventureGameControl.catchCoints.send(1)
                Haptic.tap()
                PlaySound.run()
            }
        }
        if contact.bodyB.categoryBitMask == coinCategory {
            contact.bodyB.node?.removeFromParent()
            DispatchQueue.main.async {
                AdventureGameControl.catchCoints.send(1)
                Haptic.tap()
                PlaySound.run()
            }
        }
        
        if contact.bodyA.categoryBitMask == bombCategory {
            contact.bodyA.node?.removeFromParent()
            gameOver()
            self.destroy(contact.bodyA.node)
            DispatchQueue.main.async {
                PlaySound.run5()
                AdventureGameControl.gameDidFinished.send()
            }
        }
        
        if contact.bodyB.categoryBitMask == bombCategory {
            contact.bodyB.node?.removeFromParent()
            gameOver()
            self.destroy(contact.bodyB.node)
            DispatchQueue.main.async {
                PlaySound.run5()
                AdventureGameControl.gameDidFinished.send()
            }
        }
    }
    
    
    func gameStart() {
        scene?.isPaused = false
        
        self.destroy(tiger)
        tiger = SKSpriteNode(imageNamed: tigerSkin ?? "tiger_set_1")
        tiger?.physicsBody?.categoryBitMask = coinManCategory
        tiger?.physicsBody?.contactTestBitMask = coinCategory | bombCategory
        tiger?.physicsBody?.collisionBitMask = groundAndCeilCategory
       // tiger?.physicsBody = SKPhysicsBody(rectangleOf: tiger?.size ?? .zero)
        tiger?.physicsBody = SKPhysicsBody(rectangleOf: tiger?.size ?? .zero)
        tiger?.physicsBody?.affectedByGravity = true
        tiger?.physicsBody?.contactTestBitMask = tiger?.physicsBody?.collisionBitMask ?? 0
        tiger?.position = CGPoint(x: 60, y: 140)
        tiger?.size = CGSize(width: 150, height: 160)
        tiger?.physicsBody?.mass = 0.5
        tiger?.physicsBody?.allowsRotation = false
        addChild(tiger!)
        
        
        bombTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: { (timer) in
            self.createPlate()
        })
        bombTimer?.fire()
    }
    
    func gameOver() {
        scene?.isPaused = true
        
        bombTimer?.invalidate()
    }
    
    func destroy(_ value: SKNode?) {
        guard let value else { return }
        value.removeFromParent()
    }
    
}
