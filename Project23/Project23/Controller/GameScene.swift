//
//  GameScene.swift
//  Project23
//
//  Created by Alexander Ha on 11/4/20.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    //MARK: - Properties
    
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
    
    //sound properties
    var isSwooshSoundActive = false
    var bombSoundEffect: AVAudioPlayer?
    
    //enemy properties
    var activeEnemies = [SKSpriteNode]()
    var popupTime = 0.9 //amount of time to wait between the last enemy being destroyed and a new one being created
    var sequence = [SequenceType]() //an array of our sequence type enum that defines what enemies to create
    var sequencePosition = 0 //describes where we are right now in the game
    var chainDelay = 3.0 //how long to wait before creating a new enemy when the sequence type is .chain or .fastchain
    var nextSequenceQueued = true //used so we know when all enemies are destroyed and we're ready to create more
    
    //name properties
    let bombContainerString = "bombContainer"
    let chalkDusterFont = "Chalkduster"
    let bombString = "bomb"
    let enemyString = "enemy"
    
    //MARK: - Scene
    
    override func didMove(to view: SKView) {
        
        setupBackground()
        
        setGravity()
        
        createScore()
        
        createLives()
        
        createSlices()
        
        gameStart()
        
        
    }
    
    //MARK: - Touch Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        //remove all existing points in activeSlicePoints array while keeping its storage space
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        //get the touch location and add it to the activeSlicePoints array.
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        //call the redrawActiveSlice() method to clear the slice shapes
        redrawActiveSlice()
        
        //remove actions attached to the current slice shapes.
        activeSliceFG.removeAllActions()
        activeSliceBG.removeAllActions()
        
        //set both slice shapes to be fully visible
        activeSliceFG.alpha = 1
        activeSliceBG.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        if !isSwooshSoundActive {
            playSwooshSound()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func redrawActiveSlice() {
        //array must have more than 2 points to draw a shape, will exit method if it has less than 2
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        //if we have more then 12 points in our array, we will remove the oldest ones until we have 12
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        //starts the line at first point then loop through each of the other points to continue line path
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1..<activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        //updates the paths with our design
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
    }
    
    func playSwooshSound() {
        
        isSwooshSoundActive = true
        //plays 1 of 3 sound effects
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
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
    
    //MARK: - Enemy methods
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        
        let enemy: SKSpriteNode
        var enemyType = Int.random(in: 0...6)
        
        //decides whether to force bomb and chooses the enemy type
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        
        //decides what enemy to create once enemy type is determined
        if enemyType == 0 {
            
            //new spriteNode that will hold fuse and bomb image as children
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = bombContainerString
            
            //adding bomb image and placing it inside the bombContainer
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = bombString
            enemy.addChild(bombImage)
            
            //stops bomb fuse sound effect if there is one and destroys it
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            //create a new bomb fuse sound effect and plays it
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            //create a particle emitter node and position it so that its at teh end of the bombs image's fuse
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = enemyString
        }
        
        //give random position off the bottom edge of the screen
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        //random angular velocity
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        
        //random X velocity
        let randomXVelocity: Int
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = Int.random(in: 3...5)
        } else {
            randomXVelocity = Int.random(in: 24...32)
        }
        
        //random Y velocity
        let randomYVelocity = Int.random(in: 24...32)
        
        //gives all enemies a circular physics body where they do not collide
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.collisionBitMask = 0
        
        //adds enemy to scene and appends to activeEnemies array
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    func tossEnemies() {
        
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
            
        case .one:
            createEnemy()
            
        case .twoWithBomb:
            createEnemy(forceBomb: .always)
            createEnemy(forceBomb: .always)

        case .two:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
            
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
            
        case .chain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }
            
        case .fastChain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        }

        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    func gameStart() {
        
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithBomb, .twoWithBomb, .three, .one, .chain]
        
        for _ in 0...1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in self?.tossEnemies() }
    }
    
        //MARK: - Update method Changes
    
    override func update(_ currentTime: TimeInterval) {
        var bombCount = 0
        
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeFromParent()
                    activeEnemies.remove(at: index)
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in self?.tossEnemies() }
                nextSequenceQueued = true
            }
        }
        
        for node in activeEnemies {
            if node.name == bombContainerString {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    //end of class
}

