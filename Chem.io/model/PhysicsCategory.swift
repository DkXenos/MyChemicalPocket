//
//  PhysicsCategory.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import Foundation

// MARK: - Physics Category Bitmasks
/// Bitmask constants for SpriteKit physics collision filtering.
/// Used with `categoryBitMask` and `contactTestBitMask` on SKPhysicsBody.
struct PhysicsCategory {
    static let none:     UInt32 = 0x0
    static let element:  UInt32 = 0x1 << 0  // 1
    static let molecule: UInt32 = 0x1 << 1  // 2
    static let boundary: UInt32 = 0x1 << 2  // 4
}
