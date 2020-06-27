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

enum CollisionType: UInt32 {
    case player = 1
    case shot = 2
    case enemy = 4
    case enemyShot = 8
}

class GameScene: SKScene {
    
//    let user = Bundle.main.decode(User.self, from: "user")
//    let shipInfo = Bundle.main.decode([ShipInfo].self, from: "ships")
    let waves = Bundle.main.decode([Wave].self, from: "waves")
    let enemyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types")
    
    var isPlayerAlive = true
    var levelNumber = 0
    var waveNumber = 0

    let positions = Array(stride(from: -320, through: 320, by: 80))
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        if let particles = SKEmitterNode(fileNamed: "Starfield") {
            particles.position = CGPoint(x: 0, y: frame.height)
            particles.zPosition = -1
            particles.advanceSimulationTime(60)
            addChild(particles)
            
            let ship = makeShip(type: "ship1")
            ship.position = CGPoint(x: 0, y: frame.minY + 100)
            ship.zPosition = 1
            addChild(ship)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        pruneOffscreenEntities()
        
        let activeEnemies = checkActiveEnemies()
        if activeEnemies.count == 0 {
            createWave()
        }
        fireWeapons(enemies: activeEnemies, currentTime: currentTime)
    }
    
    func pruneOffscreenEntities() {
        for child in children {
            if child.frame.maxY < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
    }
    
    func checkActiveEnemies() -> [EnemyNode] {
        return (children.compactMap { $0 as? EnemyNode })
    }
    
    func fireWeapons(enemies: [EnemyNode], currentTime: TimeInterval) {
        for enemy in enemies {
            guard frame.intersects(enemy.frame) else { continue }
            if enemy.lastFireTime + 1 < currentTime {
                enemy.lastFireTime = currentTime
                if Int.random(in: 0...6) == 0 {
                    enemy.fire()
                }
                
            }
        }
    }
    
    func makeShip(type: String) -> Ship {
        let ship = Ship(imageNamed: type)
//        ship.getPhysical(categoryBitMask: CollisionType.player.rawValue,
//                         collisionBitMask: CollisionType.player.rawValue | CollisionType.enemyShot.rawValue,
//                         contactTestBitMask: CollisionType.player.rawValue | CollisionType.enemyShot.rawValue
//        )
        
        ship.physicsBody = SKPhysicsBody(texture: ship.texture!, size: ship.texture!.size())
        physicsBody?.categoryBitMask = CollisionType.player.rawValue
        physicsBody?.collisionBitMask = CollisionType.player.rawValue | CollisionType.enemyShot.rawValue
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue | CollisionType.enemyShot.rawValue

        ship.physicsBody?.isDynamic = false

        return ship
    }

    func createWave() {
        guard isPlayerAlive else { return }
        
        if waveNumber == waves.count {
            levelNumber += 1
            waveNumber = 0
        }
        
        let currentWave = waves[waveNumber]
        waveNumber += 1
        
        let maximumEnemyType = min(enemyTypes.count, levelNumber + 1)
        let enemyType = Int.random(in: 0..<maximumEnemyType)
        let enemyOffset:CGFloat = 100
        let enemyStartOffset = 600
        
        for enemy in currentWave.enemies {
            let node = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: positions[enemy.position], y: enemyStartOffset), offset: enemy.offset, moveType: enemy.moveStyle)
            addChild(node)
        }
        
    }
}
