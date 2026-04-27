//
//  Element.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import SwiftUI
import SpriteKit

// MARK: - Element Enum
/// Represents the first 10 chemical elements with their physical properties.
/// Colors follow the standard CPK (Corey-Pauling-Koltun) coloring convention.
enum Element: String, CaseIterable, Identifiable {
    case hydrogen   = "H"
    case helium     = "He"
    case lithium    = "Li"
    case beryllium  = "Be"
    case boron      = "B"
    case carbon     = "C"
    case nitrogen   = "N"
    case oxygen     = "O"
    case fluorine   = "F"
    case neon       = "Ne"
    
    var id: String { rawValue }
    
    /// Element symbol (e.g., "H", "He")
    var symbol: String { rawValue }
    
    /// Full element name
    var name: String {
        switch self {
        case .hydrogen:  return "Hydrogen"
        case .helium:    return "Helium"
        case .lithium:   return "Lithium"
        case .beryllium: return "Beryllium"
        case .boron:     return "Boron"
        case .carbon:    return "Carbon"
        case .nitrogen:  return "Nitrogen"
        case .oxygen:    return "Oxygen"
        case .fluorine:  return "Fluorine"
        case .neon:      return "Neon"
        }
    }
    
    /// Atomic number (1-10)
    var atomicNumber: Int {
        switch self {
        case .hydrogen:  return 1
        case .helium:    return 2
        case .lithium:   return 3
        case .beryllium: return 4
        case .boron:     return 5
        case .carbon:    return 6
        case .nitrogen:  return 7
        case .oxygen:    return 8
        case .fluorine:  return 9
        case .neon:      return 10
        }
    }
    
    /// Atomic mass in unified atomic mass units (u)
    var mass: CGFloat {
        switch self {
        case .hydrogen:  return 1.008
        case .helium:    return 4.003
        case .lithium:   return 6.941
        case .beryllium: return 9.012
        case .boron:     return 10.81
        case .carbon:    return 12.011
        case .nitrogen:  return 14.007
        case .oxygen:    return 15.999
        case .fluorine:  return 18.998
        case .neon:      return 20.180
        }
    }
    
    /// Display radius for the physics node (scaled for visual clarity)
    var radius: CGFloat {
        switch self {
        case .hydrogen:  return 18
        case .helium:    return 20
        case .lithium:   return 24
        case .beryllium: return 22
        case .boron:     return 22
        case .carbon:    return 24
        case .nitrogen:  return 22
        case .oxygen:    return 22
        case .fluorine:  return 20
        case .neon:      return 20
        }
    }
    
    /// Standard CPK coloring for each element
    var color: SKColor {
        switch self {
        case .hydrogen:  return SKColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0) // White
        case .helium:    return SKColor(red: 0.85, green: 1.00, blue: 1.00, alpha: 1.0) // Cyan
        case .lithium:   return SKColor(red: 0.80, green: 0.50, blue: 1.00, alpha: 1.0) // Violet
        case .beryllium: return SKColor(red: 0.76, green: 1.00, blue: 0.00, alpha: 1.0) // Yellow-Green
        case .boron:     return SKColor(red: 1.00, green: 0.71, blue: 0.71, alpha: 1.0) // Salmon
        case .carbon:    return SKColor(red: 0.56, green: 0.56, blue: 0.56, alpha: 1.0) // Dark Gray
        case .nitrogen:  return SKColor(red: 0.19, green: 0.31, blue: 0.97, alpha: 1.0) // Blue
        case .oxygen:    return SKColor(red: 1.00, green: 0.05, blue: 0.05, alpha: 1.0) // Red
        case .fluorine:  return SKColor(red: 0.56, green: 0.88, blue: 0.31, alpha: 1.0) // Green
        case .neon:      return SKColor(red: 0.70, green: 0.89, blue: 0.96, alpha: 1.0) // Light Cyan
        }
    }
    
    /// SwiftUI color for use in the element drawer UI
    var swiftUIColor: Color {
        switch self {
        case .hydrogen:  return Color(red: 0.95, green: 0.95, blue: 0.95)
        case .helium:    return Color(red: 0.85, green: 1.00, blue: 1.00)
        case .lithium:   return Color(red: 0.80, green: 0.50, blue: 1.00)
        case .beryllium: return Color(red: 0.76, green: 1.00, blue: 0.00)
        case .boron:     return Color(red: 1.00, green: 0.71, blue: 0.71)
        case .carbon:    return Color(red: 0.56, green: 0.56, blue: 0.56)
        case .nitrogen:  return Color(red: 0.19, green: 0.31, blue: 0.97)
        case .oxygen:    return Color(red: 1.00, green: 0.05, blue: 0.05)
        case .fluorine:  return Color(red: 0.56, green: 0.88, blue: 0.31)
        case .neon:      return Color(red: 0.70, green: 0.89, blue: 0.96)
        }
    }
}
