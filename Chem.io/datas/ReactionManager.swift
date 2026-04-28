//
//  ReactionManager.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import Foundation
import SpriteKit

// MARK: - Reaction Manager
/// Singleton engine that handles order-independent, multi-step fusions.
class ReactionManager {
    static let shared = ReactionManager()
    
    private(set) var reactions: [String: Molecule] = [:]
    
    private init() {
        registerReactions()
    }
    
    /// Generates a unique, order-independent key from a list of element symbols.
    func generateKey(elements: [String]) -> String {
        var counts: [String: Int] = [:]
        for el in elements {
            counts[el, default: 0] += 1
        }
        
        let sortedKeys = counts.keys.sorted()
        var key = ""
        for k in sortedKeys {
            key += "\(k)\(counts[k]!)"
        }
        return key
    }
    
    /// Generates a unique, order-independent key from a dictionary of element components.
    func generateKey(components: [Element: Int]) -> String {
        let sortedKeys = components.keys.sorted { $0.symbol < $1.symbol }
        var key = ""
        for k in sortedKeys {
            if let count = components[k], count > 0 {
                key += "\(k.symbol)\(count)"
            }
        }
        return key
    }
    
    /// Registers a molecule into the reaction dictionary.
    private func register(_ molecule: Molecule) {
        let key = generateKey(components: molecule.components)
        reactions[key] = molecule
    }
    
    private func registerReactions() {
        // MARK: - Level 1: Simple Diatomic & Simple Compounds
        
        register(Molecule(name: "Hydrogen Gas", formula: "H₂", color: SKColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0), radius: 24, components: [.hydrogen: 2]))
        register(Molecule(name: "Oxygen Gas", formula: "O₂", color: SKColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0), radius: 30, components: [.oxygen: 2]))
        register(Molecule(name: "Nitrogen Gas", formula: "N₂", color: SKColor(red: 0.2, green: 0.3, blue: 1.0, alpha: 1.0), radius: 30, components: [.nitrogen: 2]))
        register(Molecule(name: "Fluorine Gas", formula: "F₂", color: SKColor(red: 0.56, green: 0.88, blue: 0.31, alpha: 1.0), radius: 28, components: [.fluorine: 2]))
        
        register(Molecule(name: "Lithium Fluoride", formula: "LiF", color: SKColor(red: 0.8, green: 0.7, blue: 0.9, alpha: 1.0), radius: 32, components: [.lithium: 1, .fluorine: 1]))
        register(Molecule(name: "Carbon Monoxide", formula: "CO", color: SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0), radius: 32, components: [.carbon: 1, .oxygen: 1]))
        
        // Intermediates for multi-step BeF2
        register(Molecule(name: "Beryllium Monofluoride", formula: "BeF", color: SKColor(red: 0.6, green: 0.9, blue: 0.2, alpha: 1.0), radius: 28, components: [.beryllium: 1, .fluorine: 1]))
        register(Molecule(name: "Beryllium Fluoride", formula: "BeF₂", color: SKColor(red: 0.7, green: 1.0, blue: 0.3, alpha: 1.0), radius: 36, components: [.beryllium: 1, .fluorine: 2]))
        
        // MARK: - Level 2: Chained Reactions
        
        register(Molecule(name: "Water", formula: "H₂O", color: SKColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0), radius: 32, components: [.hydrogen: 2, .oxygen: 1]))
        register(Molecule(name: "Carbon Dioxide", formula: "CO₂", color: SKColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0), radius: 36, components: [.carbon: 1, .oxygen: 2]))
        
        // O2 + H -> HO2 -> H2O2
        register(Molecule(name: "Hydroperoxyl", formula: "HO₂", color: SKColor(red: 0.9, green: 0.4, blue: 0.4, alpha: 1.0), radius: 32, components: [.hydrogen: 1, .oxygen: 2]))
        register(Molecule(name: "Hydrogen Peroxide", formula: "H₂O₂", color: SKColor(red: 0.9, green: 0.6, blue: 0.6, alpha: 1.0), radius: 36, components: [.hydrogen: 2, .oxygen: 2]))
        
        // C + H2 -> CH2 -> CH4
        register(Molecule(name: "Methylene", formula: "CH₂", color: SKColor(red: 0.5, green: 0.7, blue: 0.5, alpha: 1.0), radius: 30, components: [.carbon: 1, .hydrogen: 2]))
        register(Molecule(name: "Methane", formula: "CH₄", color: SKColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0), radius: 38, components: [.carbon: 1, .hydrogen: 4]))
        
        // N + H2 -> NH2 -> NH3
        register(Molecule(name: "Amidogen", formula: "NH₂", color: SKColor(red: 0.3, green: 0.4, blue: 1.0, alpha: 1.0), radius: 30, components: [.nitrogen: 1, .hydrogen: 2]))
        register(Molecule(name: "Ammonia", formula: "NH₃", color: SKColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1.0), radius: 34, components: [.nitrogen: 1, .hydrogen: 3]))
        
        // MARK: - Level 3: Advanced/Exotic
        
        register(Molecule(name: "Boron Nitride", formula: "BN", color: SKColor(red: 0.8, green: 0.6, blue: 0.8, alpha: 1.0), radius: 32, components: [.boron: 1, .nitrogen: 1]))
        
        // Li + O -> LiO -> Li2O
        register(Molecule(name: "Lithium Monoxide", formula: "LiO", color: SKColor(red: 0.9, green: 0.5, blue: 0.8, alpha: 1.0), radius: 30, components: [.lithium: 1, .oxygen: 1]))
        register(Molecule(name: "Lithium Oxide", formula: "Li₂O", color: SKColor(red: 1.0, green: 0.6, blue: 0.9, alpha: 1.0), radius: 36, components: [.lithium: 2, .oxygen: 1]))
        
        register(Molecule(name: "Cyanogen Radical", formula: "CN", color: SKColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0), radius: 32, components: [.carbon: 1, .nitrogen: 1]))
    }
}
