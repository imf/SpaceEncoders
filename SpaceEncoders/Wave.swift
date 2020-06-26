//
//  Wave.swift
//  SpaceEncoders
//
//  Created by Ian McFarland on 6/25/20.
//  Copyright © 2020 Ian McFarland. All rights reserved.
//

import SpriteKit

struct Wave: Codable {
    struct WaveEnemy: Codable {
        let position: Int
        let offset: CGFloat
        let moveStyle: String
    }
    
    let name: String
    let enemies: [WaveEnemy]
}
