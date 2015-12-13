//
//  TitleScene.swift
//  Serpentine
//
//  Created by Christopher Hannah on 13/12/2015.
//  Copyright © 2015 Christopher Hannah. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    override func keyDown(theEvent: NSEvent) {
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
