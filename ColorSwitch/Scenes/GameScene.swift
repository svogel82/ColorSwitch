//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Sebastian Vogel on 18.09.18.
//  Copyright © 2018 Sebastian Vogel. All rights reserved.
//

import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor (red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor (red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor (red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor (red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchstate = SwitchState.red
    var currenColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    var gravityIndex = -2.0
    let gravitiyLabel = SKLabelNode (text: "Level 1")
    
    
    override func didMove(to view: SKView) {
    setupPhysics()
    layoutScene()
     
    }
    
    func setupPhysics(){
    physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityIndex)
    physicsWorld.contactDelegate = self
    }
    
    func layoutScene(){
       backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        colorSwitch = SKSpriteNode (imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.height/6)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.height/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 60)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        
        gravitiyLabel.fontName = "AvenirNext-Bold"
        gravitiyLabel.fontSize = 60.0
        gravitiyLabel.fontColor = UIColor.white
        gravitiyLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gravitiyLabel.zPosition = ZPositions.label
        addChild(gravitiyLabel)
        spawnBall()
        
        
        
    }
    
    func updateScoreLabel(){
        scoreLabel.text = "\(score)"
    }
    
    func updateGravitiyLabel(){
        if score > 5 {
            gravitiyLabel.text = "Level 2"
        };if score > 10 {
            gravitiyLabel.text = "Level 3"
        };if score > 15{
            gravitiyLabel.text = "Level 4"
        }
        
    }
    
    func spawnBall(){
        
        currenColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currenColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.position = CGPoint (x: frame.midX, y: frame.maxY - 20)
        ball.zPosition = ZPositions.ball
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball)
    }
    
    func turnWheel(){
        if let newState = SwitchState(rawValue: switchstate.rawValue + 1){
            switchstate = newState
        }else {
            switchstate = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func gameOver(){
        UserDefaults.standard.set(score, forKey: "RecentScore")
        //UserDefaults.standard.set(gravitiyLabel, forKey: "Level")
        
        
        if score > UserDefaults.standard.integer(forKey: "Highscore"){
            UserDefaults.standard.set(score, forKey: "Highscore")
        
        
        }
        
        
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
   func updateGravity(){
        if score > 5 {
            gravityIndex = -3.0
    };if score > 10 {
            gravityIndex = -5.0
    };if score > 15{
            gravityIndex = -7.0
    }
        
    }
    
}




extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if  contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currenColorIndex == switchstate.rawValue {
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    score += 1
                    updateScoreLabel()
                    updateGravitiyLabel()
                    updateGravity()
                    setupPhysics()
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion:  {
                        ball.removeFromParent()
                        self.spawnBall()
                        
                        
                    })
                }else {
                    gameOver()
                }
            }
            
            
        }
    }
    
    
    
}
