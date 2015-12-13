//
//  GameScene.swift
//  Serpentine
//
//  Created by Christopher Hannah on 13/12/2015.
//  Copyright (c) 2015 Christopher Hannah. All rights reserved.
//

import SpriteKit
import AVFoundation

enum SNAKE_FACING {
    case Up
    case Right
    case Down
    case Left
}

class GameScene: SKScene {
    
    // CONSTANTS!
    let bitSize = CGSize(width: 16, height: 16)
    let bgColor = NSColor(calibratedRed: (1/255)*159, green: (1/255)*198, blue: (1/255)*155, alpha: 1)
    let textColor = NSColor(calibratedRed: (1/255)*53, green: (1/255)*98, blue: (1/255)*49, alpha: 1)
    let snakeColor = NSColor(calibratedRed: (1/255)*38, green: (1/255)*69, blue: (1/255)*36, alpha: 1)
    let appleColor = NSColor(calibratedRed: (1/255)*83, green: (1/255)*159, blue: (1/255)*77, alpha: 1)
    
    // TIMING!
    var timeElapsed = 0
    
    
    // THE SNAKE!
    var snakeBitPositions:[CGPoint] = [CGPoint(x: 16, y: 16), CGPoint(x: 15, y: 16), CGPoint(x: 14, y: 16)]
    var snakeBits:[SKSpriteNode] = []
    var applePosition = CGPoint(x: 0, y: 0)
    var snakeDirection = SNAKE_FACING.Right
    
    // SOUNDS!
    var appleSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("APPLE", ofType: "wav")!)
    var applePlayer = AVAudioPlayer()
    var dieSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("DIE", ofType: "wav")!)
    var diePlayer = AVAudioPlayer()
    
    // THE GAME!
    var scoreLabel = SKLabelNode()
    var gameoverLabel = SKLabelNode()
    var restartLabel = SKLabelNode()
    var score = 0
    var apples = false
    var shouldGrow = false
    
    
    func calculatePosition(bitPos: CGPoint) -> CGPoint {
        let x = ((bitPos.x-1) * bitSize.width) + 8
        let y = ((bitPos.y-1) * bitSize.height) + 8
        return CGPoint(x: x, y: y)
    }
    
    func updateSnake() {
        
        if (snakeBits.count == snakeBitPositions.count) {
            
            for (var i = 0; i < snakeBits.count; i++) {
               snakeBits[i].position = calculatePosition(snakeBitPositions[i])
                
            }
            
            
        } else if (snakeBits.count < snakeBitPositions.count) {
            for (var i = 0; i < (snakeBitPositions.count - snakeBits.count); i++) {
                snakeBits.append(getSnakeBit())
                self.addChild(snakeBits.last!)
            }
            
            for (var i = 0; i < snakeBits.count; i++) {
                snakeBits[i].position = calculatePosition(snakeBitPositions[i])
            }
            
        }
        

    }
    
    func moveSnake(grow: Bool) {
        if (grow) {
            snakeBitPositions.append(CGPoint(x: 0, y: 0))
        }
        
        for (var i = snakeBitPositions.count - 1; i > 0; i--) {
            snakeBitPositions[i] = snakeBitPositions[i-1]
        }
        
        var newPos = snakeBitPositions[0]
        
        switch snakeDirection {
        case .Up:
            newPos.y++
            break
        case .Right:
            newPos.x++
            break
        case .Down:
            newPos.y--
        case.Left:
            newPos.x--
            break
        }

        
        if (checkCollision(CGPoint(x: newPos.x, y: newPos.y)) == false) {
            snakeBitPositions[0] = newPos
        } else {
            gameover()
        }
    }
    
    func addSnakeBit() {
        
    }
    
    func getSnakeBit() -> SKSpriteNode {
        let snakeBit = SKSpriteNode(color: snakeColor, size: bitSize)
        snakeBit.name = "snakeBit"
        return snakeBit
    }
    
    func getAppleBit() -> SKSpriteNode {
        let appleBit = SKSpriteNode(color: appleColor, size: bitSize)
        appleBit.name = "appleBit"
        return appleBit
    }
    
    func changeDirection(newDirection: SNAKE_FACING) {
        switch newDirection {
        case .Up:
            if (snakeDirection == .Down) {
                break
            } else {
                snakeDirection = .Up
            }
            break
        case .Right:
            if (snakeDirection == .Left) {
                break
            } else {
                snakeDirection = .Right
            }
            break
        case .Down:
            if (snakeDirection == .Up) {
                break
            } else {
                snakeDirection = .Down
            }
            break
        case .Left:
            if (snakeDirection == .Right) {
                break
            } else {
                snakeDirection = .Left
            }
        }
    }
    
    func checkCollision(newPos: CGPoint) -> Bool {
        var collision = false
        
        for (var i = 0; i < snakeBitPositions.count; i++) {
            let pos = snakeBitPositions[i]
            
            if (newPos.x == pos.x && newPos.y == pos.y) {
                collision =  true
            }
        }
        
        if (newPos.x == applePosition.x && newPos.y == applePosition.y) {
            score++
            applePlayer.play()
            scoreLabel.text = "SCORE: \(score)"
            for child in self.children {
                if child.name == "appleBit" {
                    child.removeFromParent()
                }
            }
            shouldGrow = true
            apples = false
        }
        
        if (newPos.x == 0 || newPos.y == 0 || newPos.x == 33 || newPos.y == 33) {
            collision = true
        }
        
        return collision
    }
    
    override func keyDown(theEvent: NSEvent) {
        handleKeyEvent(theEvent, keyDown: true)
    }
    
    override func keyUp(theEvent: NSEvent) {
        handleKeyEvent(theEvent, keyDown: false)
    }
    
    func handleKeyEvent(event:NSEvent, keyDown:Bool){
        if event.modifierFlags.contains(NSEventModifierFlags.NumericPadKeyMask){
            if let theArrow = event.charactersIgnoringModifiers, keyChar = theArrow.unicodeScalars.first?.value{
                switch Int(keyChar){
                case NSUpArrowFunctionKey:
                    changeDirection(.Up)
                    updateSnake()
                    break
                case NSDownArrowFunctionKey:
                    changeDirection(.Down)
                    updateSnake()
                    break
                case NSRightArrowFunctionKey:
                    changeDirection(.Right)
                    updateSnake()
                    break
                case NSLeftArrowFunctionKey:
                    changeDirection(.Left)
                    updateSnake()
                    break
                default:
                    break
                }
            }
        } else {
            if let characters = event.characters{
                for character in characters.characters{
                    switch(character){
                    case "w":
                        moveSnake(true)
                        break
                    case "r":
                        restartGame()
                        break
                    default:
                        print(character)
                    }
                }
            }
        }
    }
    

    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = bgColor
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        scoreLabel.fontColor = textColor
        self.childNodeWithName("scoreLabel")?.removeFromParent()
        self.addChild(scoreLabel)
        gameoverLabel = self.childNodeWithName("gameoverLabel") as! SKLabelNode
        gameoverLabel.fontColor = textColor
        self.childNodeWithName("gameoverLabel")?.removeFromParent()
        self.addChild(gameoverLabel)
        gameoverLabel.hidden = true
        restartLabel = self.childNodeWithName("restartLabel") as! SKLabelNode
        restartLabel.fontColor = textColor
        self.childNodeWithName("restartLabel")?.removeFromParent()
        self.addChild(restartLabel)
        restartLabel.hidden = true
        
        do {
            applePlayer = try AVAudioPlayer(contentsOfURL: appleSound)
        } catch {
            print("No sound found by URL:\(appleSound)")
        }
        applePlayer.prepareToPlay()
        
        do {
            diePlayer = try AVAudioPlayer(contentsOfURL: dieSound)
        } catch {
            print("No sound found by URL:\(dieSound)")
        }
        diePlayer.prepareToPlay()
    }
    
    override func update(currentTime: CFTimeInterval) {
        if (timeElapsed == 5) {
            tick()
            timeElapsed = 0
        } else {
            timeElapsed++
        }
    }
    
    func tick() {
        if (shouldGrow) {
            moveSnake(true)
            shouldGrow = false
        } else {
                moveSnake(false)
        }
        updateSnake()
        generateApple()
    }
    
    func restartGame() {
        score = 0
        snakeBitPositions = [CGPoint(x: 16, y: 16), CGPoint(x: 15, y: 16), CGPoint(x: 14, y: 16)]
        snakeBits = []
        snakeDirection = SNAKE_FACING.Right
        apples = false
        shouldGrow = false
        for child in self.children {
            if (child.name == "snakeBit" || child.name == "appleBit") {
                child.removeFromParent()
            }
        }
        scoreLabel.text = "SCORE: 0"
        gameoverLabel.hidden = true
        restartLabel.hidden = true
        self.paused = false
        
    }
    
    func generateApple() {
        if (apples != true) {
            let x = randomInt(1, max: 32)
            let y = randomInt(1, max: 32)
            let appleNode = getAppleBit()
            appleNode.position = calculatePosition(CGPoint(x: x, y: y))
            applePosition = (CGPoint(x: x, y: y))
            self.addChild(appleNode)
            apples = true
        }
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func gameover() {
        diePlayer.play()
        self.paused = true
        gameoverLabel.hidden = false
        restartLabel.hidden = false
    }
}
