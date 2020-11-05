//
//  GameScene.swift
//  Project23
//
//  Created by Alexander Ha on 11/4/20.
//

import SpriteKit

class GameScene: SKScene {
    
  
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    func createScore() {
        
    }
    
    func createLives() {
        
    }
    
    func createSlices() {
        
    }
  
}
