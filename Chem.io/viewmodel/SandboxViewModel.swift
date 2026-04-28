//
//  SandboxViewModel.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import SwiftUI
import SpriteKit

// MARK: - Sandbox ViewModel
/// Bridges SwiftUI and SpriteKit by managing the physics sandbox scene
/// and exposing element spawning actions to the SwiftUI layer.
@Observable
class SandboxViewModel {
    
    /// The SpriteKit scene instance
    var scene: PhysicsSandboxScene
    
    /// Count of molecules successfully created
    var moleculesCreated: Int = 0
    
    /// Count of active element nodes on the canvas
    var activeElements: Int = 0
    
    init() {
        let scene = PhysicsSandboxScene()
        scene.scaleMode = .resizeFill
        self.scene = scene
        
        // Set up callback for molecule creation tracking
        scene.onMoleculeCreated = { [weak self] in
            self?.moleculesCreated += 1
        }
        
        scene.onElementCountChanged = { [weak self] count in
            self?.activeElements = count
        }
    }
    
    /// Spawns an element at the top-center of the scene with slight random offset.
    func spawnElement(_ element: Element) {
        scene.spawnElement(element)
    }
    
    /// Clears all nodes from the sandbox
    func clearCanvas() {
        scene.clearAllNodes()
        moleculesCreated = 0
        activeElements = 0
    }
}
