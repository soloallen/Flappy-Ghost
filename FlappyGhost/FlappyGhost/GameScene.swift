//
//  GameScene.swift
//  FlappyGhost
//
//  Created by SOLOALLEN on 6/5/16.
//  Copyright (c) 2016 SOLOALLEN. All rights reserved.
//

import SpriteKit


/* used for SKSpriteNode().physcialBody.method() such as collision / categorybitmask   */
struct physiccat {
    
    // image name, not variable name
    static let Ghost : UInt32 = 0x1 << 1    // used as flag to define unique varibles
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let scoreNodeCoin : UInt32 = 0x1 << 4
    static let Score : UInt32 = 0x1 << 5
}

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    // subview will appear in the scene
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    var wallpair = SKNode()
    var scoreLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var bgImage  = SKSpriteNode()
    var scoreNodeCoin = SKSpriteNode()
    var scoreNode = SKSpriteNode()
    
    // flag defines game on/off
    var gamestarted = Bool()
    var gameover = Bool()
    
    // action will start in the scene
    var moveandremovePipes = SKAction()

    // variables needed
    var random = CGFloat()  // used for generate random numbers to manipulate pipes
    var score = Int()       // used for show scores of users
    
    func restartScene() {
        
        self.removeAllChildren()  // clear the scene
        self.removeAllActions()   // clear all the actions will performed in the scene
        
        /* -----  set environment of app to start status  -----*/
        gameover = false
        gamestarted = false
        score = 0
        createScene()
        /*-----------------------*/
    }
    
    
    func createScene() {
        
        self.physicsWorld.contactDelegate = self  // detacting collision in the scene
        
        //print(UIFont.familyNames())
        
        /* --- for loop backgroundIamge, set two backgroundImage in line ---  */
        for i in 0..<2 {
        let background = SKSpriteNode(imageNamed: "Background")
            background.name = "background"
            
            /* --- default anchorpoint is CGFloat(0.5,0.5), set anchorpoint to CGFloat(0,0) --- */
            //background.anchorPoint = CGPoint.init(x: CGFloat(i), y: CGFloat(0))
            background.anchorPoint = CGPointZero
            
            /* --- CGPointMake() -> CGPoint return a position or set position like below --- */
            background.position = CGPointMake(CGFloat(i) * self.frame.width, 0)
            
            /* --- background image size equals to view's size --- */
            background.size = (self.view?.bounds.size)! /* --- both can self.view!.frame.size --- */

            /* ---  add twice, there are two background image in the scene,
                    corresponding to background image movement loop 
               ---*/
            self.addChild(background)
        }
        
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y:self.frame.height / 2 + 250)
        
        /* --- set score value to score board ---*/
        scoreLbl.text = "\(score)"
        
        /* --- set font-family and size and color to word --- */
        scoreLbl.fontName = "04b_19"
        scoreLbl.fontSize = 70
        scoreLbl.fontColor = SKColor.purpleColor()

        /* --- whether this node can be hidden by other node, the higher number is, the node is on the top --- */
        scoreLbl.zPosition = 10
        
        self.addChild(scoreLbl)
        
        
        ground = SKSpriteNode(imageNamed: "Ground")
        
        /* --- set ground size --- */
        ground.setScale(0.5)
        ground.position = CGPoint(x:self.frame.width / 2, y: 0 + ground.frame.height / 2)
        
        /* --- creates an rectangular body for the ground centred on the node's origion (build a body for image, so image can like real life object with shape ) --- */
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        
        /* --- define which category this physical body belongs to (now physiccat.Ground represents the ground includes all his physical elements) --- */
        ground.physicsBody?.categoryBitMask = physiccat.Ground
        
        /* --- A mask that defines which categories of physics bodies can collide with this physics body. --- */
        ground.physicsBody?.collisionBitMask = physiccat.Ghost
        
        /* --- A mask that defines which categories of bodies cause intersection notifications with this physics body.
         ( if categories defined by collisionBitMask and contactTestBitMask are the same, collision between two node will create "SKPhysicsContact" object to describe the collision, and send "SKPhysicsContact" object to contactDelegate object of the scene physic world) --- */
        ground.physicsBody?.contactTestBitMask = physiccat.Ghost
        
        
        ground.physicsBody?.affectedByGravity = false
        
        /* --- The default value is YES. If the value is NO, the physics body ignores all forces and impulses applied to it. This property is ignored on edge-based bodies; they are automatically static. (Ignore action applied to it) --- */
        ground.physicsBody?.dynamic = false
        
        ground.zPosition = 3
        self.addChild(ground)
        
        ghost = SKSpriteNode(imageNamed: "Ghost")
        
        /* --- set node's width and height ---*/  // ghost.setScale(0.3)  shrink the node in particualr percentage
        ghost.size = CGSize(width: 60, height: 70)
        
        
        /*--- format to calculate postion of subview 
                position.x = frame.origin.x(superView) + anchorPoint.x(subView) * bounds.size.width(subView)；
               position.y = frame.origin.y(superView) + anchorPoint.y(subView) * bounds.size.height(subView)；
          ---  */
        ghost.anchorPoint = CGPoint.init(x: 0.2, y: 0.5)
        ghost.position = CGPoint(x: ghost.anchorPoint.x * (self.view?.bounds.width)! , y: ghost.anchorPoint.y * self.frame.size.height)
        /* also can --- ghost.position.x = self.ghost.anchorPoint.x * self.frame.size.width
        ghost.position.y = self.ghost.anchorPoint.y * self.frame.size.height --- */
        
        /* also can --- ghost.position = CGPoint(x: self.frame.width / 2 - 100, y: self.frame.height / 2)
                    directly set the position of the ghost subView ---*/

        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.frame.height / 2)
        ghost.physicsBody?.categoryBitMask = physiccat.Ghost
        ghost.physicsBody?.collisionBitMask = physiccat.Ground | physiccat.Wall
        ghost.physicsBody?.contactTestBitMask = physiccat.Ground | physiccat.Wall | physiccat.Score
        ghost.physicsBody?.affectedByGravity = false
        ghost.physicsBody?.allowsRotation = false
        ghost.physicsBody?.dynamic = true
        ghost.zPosition = 2
        self.addChild(ghost)
        
    }
    
    /* --- called when view represents "GameScene" scene --- */
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        createScene()
    }
    
    
    func createBtn() {

        restartBtn = SKSpriteNode(imageNamed: "RestartBtn")
        restartBtn.size = CGSize(width: 200, height: 100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 170)
        restartBtn.zPosition = 15
        self.addChild(restartBtn)
        
        /* ---  let restartBtn appears more smoothly, not jump out ---
                can add more action by using SKAction.method() --- */
        restartBtn.runAction(SKAction.scaleTo(1.0, duration: 1))
        
        /* -- self.scene?.speed = 0 --- stop scene of all actions --- */
    }
    
    
     /* --- predefined methos from "SKPhysicsContactDelegate", listen collision between nodes, if collision happened, this method will be called  --- */
     func didBeginContact(contact: SKPhysicsContact) {
        
        let firstbody = contact.bodyA
        let secondbody = contact.bodyB
        
        if firstbody.categoryBitMask ==  physiccat.Score && secondbody.categoryBitMask == physiccat.Ghost ||  firstbody.categoryBitMask == physiccat.Ghost && secondbody.categoryBitMask ==  physiccat.Score {
            print("ghost with node")
            score += 1
            scoreLbl.text = "\(score)"
            
            //scoreNode.color = SKColor.greenColor()
            
            /* --- self.scene?.speed = 0 --- speed is parameter of SKAction().method --- */
        }
        
        if firstbody.categoryBitMask == physiccat.scoreNodeCoin && secondbody.categoryBitMask == physiccat.Ghost ||  firstbody.categoryBitMask == physiccat.Ghost && secondbody.categoryBitMask == physiccat.scoreNodeCoin {
            
                print("ghost with coin")
        }
        
        if firstbody.categoryBitMask == physiccat.Wall && secondbody.categoryBitMask == physiccat.Ghost ||  firstbody.categoryBitMask == physiccat.Ghost && secondbody.categoryBitMask == physiccat.Wall {
            
            print("ghost with wall")
            self.removeAllActions() /* --- stop all actions exits in the scene --- */
            
            /*  --- 
                This method enumerates the child array in order, searching for nodes whose names match the
                search parameter.
                The block is called once for each node that matches the name parameter. 
                --- */
            enumerateChildNodesWithName("WallPair", usingBlock: ({
                (node,error) in       /* --- node represents "WallPair" SpriteNode() --- */
                
                node.speed = 0        /* --- stop wall pair, so screen wont be empty --- */
               /* --- self.scene!.removeAllActions() --- can, if "self.scene?.addChidren(wallpair)" --- stop all actions exits in the scene --- */
            }))
            
            /* --- 
            Bool() default value is false, this method won't be called until collision occur, to set gameover to true and make restart button appear in the scene
               --- */
            if gameover == false  {
                
                gameover = true     /* --- stop pipes move --- */
                createBtn()
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            /* Called when a touch begins */
    
        /* --- game start when screen is touched, because action will run forever, so set "gamestarted" to true ---*/
        if( gamestarted == false) {
    
            gamestarted = true
            
            /* --- set gravity affects node in physic world in scene --- */
            ghost.physicsBody?.affectedByGravity = true
            
            
            /* --- 
                call createWall() to create walls as Action-1  |
                set delat time as Action-2                     |
                                                               |--> create wall loop
                set (Action-1, Action-2) as a sequence         |
                run this sequence forever                      |
             --- */
            let spawn  = SKAction.runBlock({
                
                () in
                self.createWalls()
                
            })
            let delay = SKAction.waitForDuration(0.9)
            
            let spawndelay  = SKAction.sequence([spawn,delay])
            let spawn_delay_forever  = SKAction.repeatActionForever(spawndelay)
            self.runAction(spawn_delay_forever)
            
            
            /* --- 
                    set distance pipes prepare to move                          |
                    set move direction and distance and duration as Action-1    |
                    set remove pipes as Action_2                                |
                                                                                |--> remove wall loop
                    set (Action-1, Action-2) as a sequence                      |
                    run this sequence forever (called in the createWalls(),     |
                    and createWalls() is running forever)                       |
             
             
             --- */
            let distance  = CGFloat(self.frame.width )//+ wallpair.frame.width)
            
            let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval (0.004 * distance))
            let removePipes = SKAction.removeFromParent()
            
            moveandremovePipes  = SKAction.sequence([movePipes,removePipes])
            
            
            /* ---
                    make "ghost" jump when touch screen 
                    because scene is a simulated physic world now, set "ghost" velocity to zero
                    make sure "ghost" jump the same height every time
             --- */
            ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        
        }
        else{
            
            if gameover == true {
                /* --- do nothing
                       and opration is done in method "didContactBegin"
                   --- */
                
            }else{
                
                ghost.physicsBody?.velocity = CGVectorMake(0, 0)
                ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            }
        }
        
        
        for touch in touches {
        
            let location  = touch.locationInNode(self)  // return current location of touch
            
            if gameover == true {
            
                if restartBtn.containsPoint(location) {  // means user clicks the buttom
                    
                    restartScene()
                }
            }
        }
}
    
    func createWalls() {
        
        scoreNodeCoin = SKSpriteNode(imageNamed: "Coin")
        
        scoreNodeCoin.size = CGSize(width:70, height: 70)
        scoreNodeCoin.position = CGPoint(x: self.frame.width , y: self.frame.height / 2 )
        scoreNodeCoin.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNodeCoin.size)
        scoreNodeCoin.physicsBody?.categoryBitMask = physiccat.scoreNodeCoin
        scoreNodeCoin.physicsBody?.collisionBitMask = 0
        scoreNodeCoin.physicsBody?.contactTestBitMask = physiccat.Ghost
        scoreNodeCoin.physicsBody?.affectedByGravity = false
        scoreNodeCoin.physicsBody?.dynamic = false
        
        scoreNode = SKSpriteNode()
        
        scoreNode.size = CGSize(width:3,height: 300)
        scoreNode.position = CGPoint(x: self.frame.width , y: self.frame.height / 2 )
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = physiccat.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = physiccat.Ghost
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.color = SKColor.magentaColor()
        
        wallpair = SKNode()
        wallpair.name = "WallPair"
        
        let topwall = SKSpriteNode(imageNamed: "Wall")
        let btmwall = SKSpriteNode(imageNamed: "Wall")
//        
//        topwall.setScale(0.1)
//        btmwall.setScale(0.1)
        
        topwall.size = CGSize(width:30, height: 550)
       // topwall.color = SKColor.blueColor()
        btmwall.size = CGSize(width:30, height: 550)
        //btmwall.color = SKColor.orangeColor()

        
        topwall.position = CGPoint(x: self.frame.width , y: self.frame.height / 2  + 400 )
        btmwall.position = CGPoint(x: self.frame.width , y: self.frame.height / 2  - 400 )
        
        topwall.physicsBody = SKPhysicsBody(rectangleOfSize: topwall.size)
        topwall.physicsBody?.categoryBitMask  = physiccat.Wall
        topwall.physicsBody?.collisionBitMask = physiccat.Ghost
        topwall.physicsBody?.contactTestBitMask = physiccat.Ghost
        topwall.physicsBody?.affectedByGravity = false
        topwall.physicsBody?.dynamic  = false
        
        
        btmwall.physicsBody = SKPhysicsBody(rectangleOfSize: btmwall.size)
        btmwall.physicsBody?.categoryBitMask  = physiccat.Wall
        btmwall.physicsBody?.collisionBitMask = physiccat.Ghost
        btmwall.physicsBody?.contactTestBitMask = physiccat.Ghost
        btmwall.physicsBody?.affectedByGravity = false
        btmwall.physicsBody?.dynamic  = false
        
        
        /* ---  upside down --- */
        topwall.zRotation = CGFloat(M_PI)
        
        
        wallpair.addChild(topwall)
        wallpair.addChild(btmwall)
        wallpair.addChild(scoreNode)
        wallpair.addChild(scoreNodeCoin)
        wallpair.zPosition = 1
        
        let ransomPosition = CGFloat.random(min: -200, max: 200)
        wallpair.position.y = wallpair.position.y + ransomPosition
        wallpair.runAction(moveandremovePipes)
        /* --- self.scene?.addChild(wallpair) --- */
        self.addChild(wallpair)
        
    }

       override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if gamestarted == true {
            if gameover == false {
                /* can not remove "if gameover == false" condition --- gamestarted value conflict in method "touchesBegan" and "didBeginContact" --- */
            
                enumerateChildNodesWithName("background", usingBlock: ({
                    
                    (node,error) in
                    
                    self.bgImage = node as! SKSpriteNode;()
                    
                    /* --- while app is running, backgound image move to left by speed of 4 pixels --- */
                    self.bgImage.position = CGPoint(x: self.bgImage.position.x - 4, y: self.bgImage.position.y)
                    
                    /* --- when the first background image totally left screen,    |
                                                                                   |--> background image movement
                           add third background image next to second image[loop]   |
                     --- */
                    if self.bgImage.position.x <= -self.bgImage.size.width {
                        
                        self.bgImage.position = CGPointMake(self.bgImage.position.x + self.bgImage.size.width * 2, self.bgImage.position.y)
                    }
                }))
            }
        }
    }
}
