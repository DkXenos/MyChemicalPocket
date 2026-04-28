//
//  Molecule.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import SpriteKit

// MARK: - Molecule
/// Represents a chemical compound formed by fusing multiple elements.
struct Molecule {
    /// Display name (e.g., "Water")
    let name: String
    
    /// Chemical formula (e.g., "H₂O")
    let formula: String
    
    /// Display color for the molecule node
    let color: SKColor
    
    /// Display radius for the molecule node
    let radius: CGFloat
    
    /// The constituent elements and their counts
    let components: [Element: Int]
}
