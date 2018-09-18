//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Sebastian Vogel on 18.09.18.
//  Copyright © 2018 Sebastian Vogel. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    
    override func didMove(to view: SKView) {
    setupPhysics()
    layoutScene()
     
    }
    
    func setupPhysics(){
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
    physicsWorld.contactDelegate = self
    }
    
    func layoutScene(){
       backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        colorSwitch = SKSpriteNode (imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.height/6)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.height/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        spawnBall()
    }
    
    func spawnBall(){
        let ball = SKSpriteNode ( imageNamed: "ball")
        ball.size = CGSize (width: 30.0, height: 30.0)
        ball.position = CGPoint (x: frame.midX, y: frame.maxY - 20)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball)
    }
}




extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if  contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory {
            
            
        }
    }
    
    
    
}
