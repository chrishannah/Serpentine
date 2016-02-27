//
//  GameScene.swift
//  Serpentine-TV
//
//  Created by Christopher Hannah on 15/12/2015.
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
    let bitSize = CGSize(width: 30, height: 30)
    let bgColor = UIColor(red: (1/255)*154, green: (1/255)*217, blue: (1/255)*154, alpha: 1)
    let appleColor = UIColor.whiteColor()
    let snakeColor = UIColor(red: (1/255)*31, green: (1/255)*43, blue: (1/255)*31, alpha: 1)
    let textColor = UIColor(red: (1/255)*91, green: (1/255)*127, blue: (1/255)*91, alpha: 1)
    
    // SCREEN SIZE
    var midX:CGFloat = 0
    var midY:CGFloat = 0
    var maxX:CGFloat = 0
    var maxY:CGFloat = 0
    
    // TIMING!
    var timeElapsed = 0
    
    
    // THE SNAKE!
    var snakeBitPositions:[CGPoint] = []
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
    var highscoreLabel = SKLabelNode()
    var gameoverLabel = SKLabelNode()
    var restartLabel = SKLabelNode()
    var score = 0
    var highscore = 99
    var apples = false
    var shouldGrow = false
    
    
    func calculatePosition(bitPos: CGPoint) -> CGPoint {
        let x = ((bitPos.x-1) * bitSize.width) + (bitSize.width / 2)
        let y = ((bitPos.y-1) * bitSize.height) + (bitSize.height / 2)
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
            ateApple()
        }
        
        if (newPos.x == 0 || newPos.y == 0 || newPos.x > maxX || newPos.y >= maxY) {
            collision = true
        }
        
        return collision
    }
    
    func ateApple() {
        score++
        
        _ = saveScore(score)
        
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
    
    func swipedRight(sender: UISwipeGestureRecognizer) {
        moveRight()
    }
    
    func swipedLeft(sender: UISwipeGestureRecognizer) {
        moveLeft()
    }
    
    func swipedUp(sender: UISwipeGestureRecognizer) {
        moveUp()
    }
    
    func swipedDown(sender: UISwipeGestureRecognizer) {
        moveDown()
    }
    
    func moveLeft() {
        changeDirection(.Left)
        updateSnake()
    }
    
    func moveRight() {
        changeDirection(.Right)
        updateSnake()
    }
    
    func moveUp() {
        changeDirection(.Up)
        updateSnake()
    }
    
    func moveDown() {
        changeDirection(.Down)
        updateSnake()
    }

    
    
    override func didMoveToView(view: SKView) {
        
        // Register Swipe Events
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        var width:CGFloat = 1920
        var height:CGFloat = 1080
        width = self.size.width
        height = self.size.height
        print("View Bounds: \(view.bounds)")
        print("Scene Size: \(self.size)")
        midX = (width/bitSize.width)/2
        midY = (height/bitSize.height)/2
        midX = CGFloat(Int(midX))
        midY = CGFloat(Int(midY))
        maxX = (width/bitSize.width)
        maxY = (height/bitSize.height)
        
        highscore = loadHighscore()
        
        self.backgroundColor = bgColor
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        scoreLabel.fontColor = textColor
        self.childNodeWithName("scoreLabel")?.removeFromParent()
        self.addChild(scoreLabel)
        highscoreLabel = self.childNodeWithName("highscoreLabel") as! SKLabelNode
        highscoreLabel.fontColor = textColor
        highscoreLabel.text = "HIGH: \(highscore)"
        self.childNodeWithName("highscoreLabel")?.removeFromParent()
        self.addChild(highscoreLabel)
        gameoverLabel = self.childNodeWithName("gameoverLabel") as! SKLabelNode
        gameoverLabel.fontColor = UIColor.whiteColor()
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
        
        restartGame()
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
        snakeBitPositions = [CGPoint(x: midX, y: midY), CGPoint(x: midX-1, y: midY), CGPoint(x: midX-3, y: midY)]
        snakeBits = []
        snakeDirection = SNAKE_FACING.Right
        apples = false
        shouldGrow = false
        setUpUI()
        self.paused = false
        
    }
    
    func setUpUI() {
        for child in self.children {
            if (child.name == "snakeBit" || child.name == "appleBit") {
                child.removeFromParent()
            }
        }
        
        scoreLabel.text = "SCORE: 0"
        highscoreLabel.text = "HIGH: \(highscore)"
        scoreLabel.position.y = scoreLabel.frame.height / 2
        highscoreLabel.position.y = highscoreLabel.frame.height / 2
        gameoverLabel.hidden = true
        restartLabel.hidden = true
    }
    
    func generateApple() {
        if (apples != true) {
            let appleNode = getAppleBit()
            let appleLoc = generateRandomPoint(excluding: snakeBitPositions)
            appleNode.position = calculatePosition(appleLoc)
            applePosition = (appleLoc)
            self.addChild(appleNode)
            apples = true
        }
    }
    
    func generateRandomPoint(excluding excludedPoints: [CGPoint]) -> CGPoint {
        let x = randomInt(1, max: Int(maxX))
        let y = randomInt(1, max: Int(maxY))
        let point = CGPoint(x: x, y: y)
        var pointAcceptable = true
        
        for exPoint in excludedPoints {
            if point == exPoint {
                pointAcceptable = false
            }
        }
        
        if (pointAcceptable) {
            return point
        } else {
            return generateRandomPoint(excluding: excludedPoints)
        }
        
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func gameover() {
        diePlayer.play()
        self.paused = true
        let isHighscore = saveScore(score)
        if (isHighscore) {
            saveScore(highscore)
        }
        gameoverLabel.hidden = false
        restartLabel.hidden = false
    }
    
    func saveScore(score: Int) -> Bool {
        if (score > highscore) {
            highscore = score
            highscoreLabel.text = "HIGH: \(highscore)"
            saveHighscore(highscore)
            return true
        }
        
        return false
    }
    
    func loadHighscore() -> Int {
        var hScore = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        hScore = defaults.integerForKey("serpentineHighscore")
        highscoreLabel.text = "HIGH: \(highscore)"
        return hScore
    }
    
    func saveHighscore(hScore: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(hScore, forKey: "serpentineHighscore")
        defaults.synchronize()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.paused) {
            restartGame()
        }
    }
}
