//
//  AdventureGame.swift
//  sweet_game
//
//  Created by Yevhen Khyzhniak on 11.03.2024.
//

import SwiftUI
import SpriteKit
import GameplayKit
import AVFoundation
import Combine

struct Tiger: Codable, Hashable {
    
    static func == (lhs: Tiger, rhs: Tiger) -> Bool {
        return lhs.level == rhs.level
    }
    
    init(level: Int) {
        self.level = level
        self.unlocked = level == 1 ? .unlocked : .locked
    }
    
    let level: Int
    
    var unlocked: State
    
    
    var levelString: String {
        return String(format: "%d", level)
    }
    
    enum State: Codable, Hashable {
        case locked
        case unlocked
        case finished
    }
    
}

struct AdventureGame: View {
    
    @Injected(\.router) private var router
    
    @State private var coins: Int = 0 {
        willSet {
            GamesBusines.coins = newValue
        }
    }
    
    var body: some View {
        AdventureGameContentView(size: UIScreen.main.bounds.size, level: .low)
            .overlay(
                HStack(spacing: 20) {
                    BackButtonView() {
                        self.router.presentFullScreen(.showMain)
                    }
                    Spacer(minLength: 1)
                    BalanceRowView(balance: self.coins)
                        .padding(.leading, 40)
                    
                    Button {
                        //self.action()
                    } label: {
                        Image("pause_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }

                    
                }
                    .padding(.horizontal, 20).padding(.top, 40), alignment: .top
            )
            .onAppear {
                self.coins = GamesBusines.coins
            }
    }
}

struct AdventureGameContentView: View {
    
    let size: CGSize
    let level: SweetBlissGame.Level
    
    var scene: SKScene {
        let scene = AdventureGameSprite(size: size)
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .frame(width: size.width, height: size.height)
            .ignoresSafeArea()
    }
}


class AdventureGameSprite: SKScene, SKPhysicsContactDelegate {
    
    var cancellable: Set<AnyCancellable> = []
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    deinit {
        self.cancellable = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var coinMan : SKSpriteNode?
    var coinTimer : Timer?
    var bombTimer:Timer?
    var ceil : SKSpriteNode?
    var yourScoreLabel : SKLabelNode?
    var finalScoreLabel : SKLabelNode?
    var scoreLabel : SKLabelNode?
    
    let coinManCategory : UInt32 = 0x1 << 1
    let coinCategory : UInt32 = 0x1 << 2
    let bombCategory : UInt32 = 0x1 << 3
    let groundAndCeilCategory : UInt32 = 0x1 << 4
    
    var score = 0
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "adventure_bg")
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.blendMode = .replace
        background.zPosition = -8
        addChild(background)
        
        coinMan = SKSpriteNode(imageNamed: "tiger_set_1")
        coinMan?.physicsBody?.categoryBitMask = coinManCategory
        coinMan?.physicsBody?.contactTestBitMask = coinCategory | bombCategory
        coinMan?.physicsBody?.collisionBitMask = groundAndCeilCategory
        coinMan?.position = CGPoint(x: 60, y: 140)
        coinMan?.size = CGSize(width: 150, height: 160)
        addChild(coinMan!)
        
        ceil = childNode(withName: "ceil") as? SKSpriteNode
        ceil?.physicsBody?.categoryBitMask = groundAndCeilCategory
        ceil?.physicsBody?.collisionBitMask = coinManCategory
        
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        
        startTimers()
    }
    
    func startTimers() {
        coinTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.createCoin()
        })
        coinTimer?.fire()
        
        bombTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: { (timer) in
            self.createBomb()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if scene?.isPaused == false {
            coinMan?.physicsBody?.applyForce(CGVector(dx: 0, dy: 100_000))
        }
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let theNodes = nodes(at: location)
            
            for node in theNodes {
                if node.name == "play" {
                    score = 0
                    node.removeFromParent()
                    finalScoreLabel?.removeFromParent()
                    yourScoreLabel?.removeFromParent()
                    scene?.isPaused = false
                    scoreLabel?.text = "Score: \(score)"
                    startTimers()
                }
            }
        }
    }
    
    func createCoin() {
        let coin = SKSpriteNode(imageNamed: "coins")
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = coinManCategory
        coin.physicsBody?.collisionBitMask = 0
        coin.size = CGSize(width: 50, height: 50)
        addChild(coin)
        
        let maxY = size.height / 2 - coin.size.height / 2
        let minY = -size.height / 2 + coin.size.height / 2
        let range = maxY - minY
        let coinY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        coin.position = CGPoint(x: UIScreen.main.bounds.width * 2, y: coinY)
        
        let moveLeft = SKAction.moveBy(x: -UIScreen.main.bounds.width * 2, y: 0, duration: 4)
        
        coin.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
    }
    
    func createBomb() {
        let bomb = [SKSpriteNode(imageNamed: "car"), SKSpriteNode(imageNamed: "crate"), SKSpriteNode(imageNamed: "stone")].randomElement()!
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = coinManCategory
        bomb.physicsBody?.collisionBitMask = 0
        addChild(bomb)
        
        let maxY = size.height / 2 - bomb.size.height / 2
        let minY = -size.height / 2 + bomb.size.height / 2
        let range = maxY - minY
        //let bombY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        bomb.position = CGPoint(x: UIScreen.main.bounds.width * 2, y: 100)
        
        let moveLeft = SKAction.moveBy(x: -UIScreen.main.bounds.width * 2, y: 0, duration: 6)
        
        bomb.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == coinCategory {
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
        }
        if contact.bodyB.categoryBitMask == coinCategory {
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel?.text = "Score: \(score)"
        }
        
        if contact.bodyA.categoryBitMask == bombCategory {
            contact.bodyA.node?.removeFromParent()
            gameOver()
        }
        
        if contact.bodyB.categoryBitMask == bombCategory {
            contact.bodyB.node?.removeFromParent()
            gameOver()
        }
    }
    
    func gameOver() {
        scene?.isPaused = true
        
        coinTimer?.invalidate()
        bombTimer?.invalidate()
        
        yourScoreLabel = SKLabelNode(text: "Your Score:")
        yourScoreLabel?.position = CGPoint(x: 0, y: 200)
        yourScoreLabel?.fontSize = 100
        yourScoreLabel?.zPosition = 1
        if yourScoreLabel != nil {
            addChild(yourScoreLabel!)
        }
        
        finalScoreLabel = SKLabelNode(text: "\(score)")
        finalScoreLabel?.position = CGPoint(x: 0, y: 0)
        finalScoreLabel?.fontSize = 200
        finalScoreLabel?.zPosition = 1
        if finalScoreLabel != nil {
            addChild(finalScoreLabel!)
        }
        
        let playButton = SKSpriteNode(imageNamed: "play")
        playButton.position = CGPoint(x: 0, y: -200)
        playButton.name = "play"
        playButton.zPosition = 1
        addChild(playButton)
    }
    
}
