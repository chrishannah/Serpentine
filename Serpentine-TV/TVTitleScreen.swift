//
//  TVTitleScreen.swift
//  Serpentine
//
//  Created by Christopher Hannah on 15/12/2015.
//  Copyright © 2015 Christopher Hannah. All rights reserved.
//

import SpriteKit

class TVTitleScreen: SKScene {
    
    // CONSTANTS!
    let bitSize = CGSize(width: 16, height: 16)
    let bgColor = UIColor(red: (1/255)*154, green: (1/255)*217, blue: (1/255)*154, alpha: 1)
    let appleColor = UIColor.whiteColor()
    let snakeColor = UIColor(red: (1/255)*31, green: (1/255)*43, blue: (1/255)*31, alpha: 1)
    let textColor = UIColor(red: (1/255)*91, green: (1/255)*127, blue: (1/255)*91, alpha: 1)
    
    // LABELS!
    var titleLabel = SKLabelNode()
    var playLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        print("AWAKE!")
        titleLabel = self.childNodeWithName("titleLabel") as! SKLabelNode
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.position = CGPoint(x: self.frame.width/2, y: (self.frame.height/2)-100)
        self.childNodeWithName("titleLabel")?.removeFromParent()
        self.addChild(titleLabel)
        playLabel = self.childNodeWithName("playLabel") as! SKLabelNode
        playLabel.fontColor = textColor
        playLabel.position = CGPoint(x: self.frame.width/2, y: (self.frame.height/2)+100)
        self.childNodeWithName("playLabel")?.removeFromParent()
        self.addChild(playLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        runGame()
    }
    
    func runGame() {
        let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
        
        if let nextScene = GameScene(fileNamed: "GameScene") {
            nextScene.scaleMode = .AspectFill
            
            scene?.view?.presentScene(nextScene, transition: transition)
        }
        
    }
    
    
}
