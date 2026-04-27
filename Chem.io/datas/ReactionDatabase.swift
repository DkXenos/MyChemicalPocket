//
//  ReactionDatabase.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import Foundation

// MARK: - Reaction Database
/// Static database that checks if a collection of elements can react to form a molecule.
/// Uses switch-case statements for explicit, readable reaction matching.
struct ReactionDatabase {
    
    /// Checks if the given elements can form a known molecule.
    /// Elements are sorted by atomic number and converted to a signature string
    /// for deterministic matching via switch-case.
    ///
    /// - Parameter elements: The array of elements to check.
    /// - Returns: A `Molecule` if a valid reaction exists, otherwise `nil`.
    static func checkReaction(elements: [Element]) -> Molecule? {
        // Sort elements by atomic number for consistent matching
        let sorted = elements.sorted { $0.atomicNumber < $1.atomicNumber }
        
        // Create a signature string from sorted element symbols
        let signature = sorted.map { $0.symbol }.joined(separator: "+")
        
        // Match reactions using switch-case (as per requirements)
        switch signature {
        // Hydrogen Fluoride: H + F → HF
        case "H+F":
            return .hydrogenFluoride
            
        // Lithium Hydride: H + Li → LiH
        case "H+Li":
            return .lithiumHydride
            
        // Water: H + H + O → H₂O
        case "H+H+O":
            return .water
            
        // Carbon Dioxide: C + O + O → CO₂
        case "C+O+O":
            return .carbonDioxide
            
        // Ammonia: H + H + H + N → NH₃
        case "H+H+H+N":
            return .ammonia
            
        // Methane: H + H + H + H + C → CH₄
        case "C+H+H+H+H":
            return .methane
            
        // No known reaction
        default:
            return nil
        }
    }
}
