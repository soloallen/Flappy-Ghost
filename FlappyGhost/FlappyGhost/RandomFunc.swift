//
//  RandomFunc.swift
//  FlappyGhost
//
//  Created by SOLOALLEN on 11/5/16.
//  Copyright © 2016 SOLOALLEN. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    public static func random() -> CGFloat {
    
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)  /* --- get a ratio between [0 <--> 1] ---*/
    }
    
    public static func random (min min : CGFloat, max : CGFloat) -> CGFloat {
    
        return CGFloat.random() * (max - min) + min
    }

}