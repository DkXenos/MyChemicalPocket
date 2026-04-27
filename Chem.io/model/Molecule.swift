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
    
    /// The sorted list of elements required to form this molecule
    let components: [Element]
}

// MARK: - Predefined Molecules
extension Molecule {
    /// Water — H₂O
    static let water = Molecule(
        name: "Water",
        formula: "H₂O",
        color: SKColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0),
        radius: 32,
        components: [.hydrogen, .hydrogen, .oxygen].sorted { $0.atomicNumber < $1.atomicNumber }
    )
    
    /// Methane — CH₄
    static let methane = Molecule(
        name: "Methane",
        formula: "CH₄",
        color: SKColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0),
        radius: 36,
        components: [.carbon, .hydrogen, .hydrogen, .hydrogen, .hydrogen].sorted { $0.atomicNumber < $1.atomicNumber }
    )
    
    /// Ammonia — NH₃
    static let ammonia = Molecule(
        name: "Ammonia",
        formula: "NH₃",
        color: SKColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0),
        radius: 34,
        components: [.nitrogen, .hydrogen, .hydrogen, .hydrogen].sorted { $0.atomicNumber < $1.atomicNumber }
    )
    
    /// Hydrogen Fluoride — HF
    static let hydrogenFluoride = Molecule(
        name: "Hydrogen Fluoride",
        formula: "HF",
        color: SKColor(red: 0.7, green: 1.0, blue: 0.5, alpha: 1.0),
        radius: 28,
        components: [.hydrogen, .fluorine].sorted { $0.atomicNumber < $1.atomicNumber }
    )
    
    /// Carbon Dioxide — CO₂
    static let carbonDioxide = Molecule(
        name: "Carbon Dioxide",
        formula: "CO₂",
        color: SKColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0),
        radius: 34,
        components: [.carbon, .oxygen, .oxygen].sorted { $0.atomicNumber < $1.atomicNumber }
    )
    
    /// Lithium Hydride — LiH
    static let lithiumHydride = Molecule(
        name: "Lithium Hydride",
        formula: "LiH",
        color: SKColor(red: 0.9, green: 0.7, blue: 1.0, alpha: 1.0),
        radius: 30,
        components: [.lithium, .hydrogen].sorted { $0.atomicNumber < $1.atomicNumber }
    )
}
