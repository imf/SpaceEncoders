//
//  Extensions.swift
//  SpaceEncoders
//
//  Created by Ian McFarland on 6/26/20.
//  Copyright © 2020 Ian McFarland. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    func getPhysical(categoryBitMask: UInt32, collisionBitMask: UInt32, contactTestBitMask: UInt32) {
        physicsBody = SKPhysicsBody(texture: self.texture!, size: self.texture!.size())
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.collisionBitMask = collisionBitMask
        physicsBody?.contactTestBitMask = contactTestBitMask
    }
}
