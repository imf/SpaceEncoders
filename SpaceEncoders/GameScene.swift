//
//  GameScene.swift
//  SpaceEncoders
//
//  Created by Ian McFarland on 6/25/20.
//  Copyright © 2020 Ian McFarland. All rights reserved.
//

import SpriteKit


class Ship: SKSpriteNode {
}

class GameScene: SKScene {
    
//    let user = Bundle.main.decode(User.self, from: "user")
    let waves = Bundle.main.decode([Wave].self, from: "waves")
    let wnwmyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types")

    override func didMove(to view: SKView) {
        if let particles = SKEmitterNode(fileNamed: "Starfield") {
            particles.position = CGPoint(x: 0, y: frame.height)
            particles.zPosition = -1
            particles.advanceSimulationTime(60)
            addChild(particles)
            
            let ship = MakeShip(type: "ship1")
            ship.position = CGPoint(x: 0, y: 0 - frame.height / 2.6)
            ship.zPosition = 1
            addChild(ship)
        }
    }
    
    func MakeShip(type: String) -> Ship {
        return Ship(imageNamed: type)
    }

    
}
