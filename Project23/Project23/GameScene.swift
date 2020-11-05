//
//  GameScene.swift
//  Project23
//
//  Created by Alexander Ha on 11/4/20.
//

import SpriteKit

class GameScene: SKScene {
    
    //score tracker
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score \(score)"
        }
    }
    
    //lives
    var livesImage = [SKSpriteNode]()
    var lives = 3
    
    //slice properties
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()
    
    override func didMove(to view: SKView) {
        
        setupBackground()
        
        setGravity()
        
        createScore()
        
        createLives()
        
        createSlices()
        
    }
    
    //MARK: - Touch Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
        
    }
    
    
    func redrawActiveSlice() {
        
    }
    //MARK: - Initial Setup Methods
    
    func createScore() {
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        //adding gameScore to screen
        addChild(gameScore)
        
        //changing position of gameScore
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    func createLives() {
        
        //creates 3 lives at different x positions with a fixed y position and adds it to livesImage: an array of SKSpriteNodes
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            livesImage.append(spriteNode)
        }
        
    }
    
    func createSlices() {
        
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
        
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
    }
    
    func setGravity() {
        //lower default gravity
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        //lower speed at which movement occurs
        physicsWorld.speed = 0.85
    }
}
