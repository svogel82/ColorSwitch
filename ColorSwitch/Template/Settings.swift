//
//  Settings.swift
//  ColorSwitch
//
//  Created by Sebastian Vogel on 18.09.18.
//  Copyright © 2018 Sebastian Vogel. All rights reserved.
//

import SpriteKit

enum PhysicsCategories {
    static let none: UInt32 = 0
    static let ballCategory: UInt32 = 0x1 //1
    static let switchCategory: UInt32 = 0x1 << 1 //10
    
}

enum ZPositions {
    static let label: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorSwitch: CGFloat = 2
}
