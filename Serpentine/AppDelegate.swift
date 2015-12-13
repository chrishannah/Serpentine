//
//  AppDelegate.swift
//  Serpentine
//
//  Created by Christopher Hannah on 13/12/2015.
//  Copyright (c) 2015 Christopher Hannah. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            self.skView!.presentScene(scene)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = false
            self.skView!.showsNodeCount = false
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
