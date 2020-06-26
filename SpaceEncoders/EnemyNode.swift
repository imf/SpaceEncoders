//
//  EnemyNode.swift
//  SpaceEncoders
//
//  Created by Ian McFarland on 6/25/20.
//  Copyright © 2020 Ian McFarland. All rights reserved.
//

import SpriteKit

class EnemyNode: SKSpriteNode {
    var type: EnemyType
    var lastFireTime: Double = 0
    var shields: Int
    
    init(type: EnemyType, startPosition: CGPoint, offset: CGFloat, moveType: String) {
        self.type = type
        shields = type.shields
        let texture = SKTexture(imageNamed: type.name)
        super.init(texture: texture, color: .white, size: texture.size())

        position = CGPoint(x: startPosition.x, y: startPosition.y - offset)

        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = CollisionType.enemy.rawValue
        physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.shot.rawValue
        physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.shot.rawValue
        name = "enemy"
        
        configureMovement(moveType: moveType)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("No bueno.")
    }
    
    func configureMovement(moveType: String) {
        let path = UIBezierPath()
        path.move(to: .zero)
        
        switch moveType {
        case "straight":
            path.addLine(to: CGPoint(x: 0, y: -10000))
        default:
            path.addCurve(to: CGPoint(x: 0, y: -3500), controlPoint1: CGPoint(x: -position.x * 4, y: 0), controlPoint2: CGPoint(x: -position.x, y: -1000))
        }
        let movement = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: type.speed)
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        run(sequence)
    }
}
