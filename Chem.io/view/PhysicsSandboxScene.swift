//
//  PhysicsSandboxScene.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import SpriteKit

// MARK: - Physics Sandbox Scene
/// The core SpriteKit scene that handles element physics, drag interactions,
/// collision detection, and chemical fusion logic.
class PhysicsSandboxScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    
    /// The node currently being dragged by the user
    private var selectedNode: SKNode?
    
    /// Proximity radius for scanning nearby elements during collision
    private let fusionProximityRadius: CGFloat = 60.0
    
    /// Callback when a molecule is successfully created
    var onMoleculeCreated: (() -> Void)?
    
    /// Callback when the element count changes
    var onElementCountChanged: ((Int) -> Void)?
    
    /// Tracks element nodes currently on the canvas
    private var elementNodes: Set<SKNode> = [] {
        didSet {
            onElementCountChanged?(elementNodes.count)
        }
    }
    
    // MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        setupScene()
        setupBoundary()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        // Rebuild boundary when size changes (rotation, etc.)
        if oldSize != .zero {
            setupBoundary()
        }
    }
    
    // MARK: - Scene Setup
    
    private func setupScene() {
        backgroundColor = SKColor(red: 0.04, green: 0.05, blue: 0.15, alpha: 1.0) // Dark navy #0A0E27
        
        // Configure gravity — gentle pull downward
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
        physicsWorld.contactDelegate = self
        
        // Add subtle background star particles for visual polish
        addBackgroundParticles()
    }
    
    private func setupBoundary() {
        // Remove old boundary if it exists
        childNode(withName: "boundary")?.removeFromParent()
        
        // Create edge loop boundary so elements stay on screen
        let boundary = SKNode()
        boundary.name = "boundary"
        boundary.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        boundary.physicsBody?.categoryBitMask = PhysicsCategory.boundary
        boundary.physicsBody?.friction = 0.5
        boundary.physicsBody?.restitution = 0.1
        addChild(boundary)
    }
    
    private func addBackgroundParticles() {
        // Remove existing particles
        childNode(withName: "bgParticles")?.removeFromParent()
        
        // Create subtle floating particle effect
        let particleNode = SKNode()
        particleNode.name = "bgParticles"
        
        for _ in 0..<30 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...1.5))
            star.fillColor = SKColor(white: 1.0, alpha: CGFloat.random(in: 0.1...0.35))
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...max(size.width, 400)),
                y: CGFloat.random(in: 0...max(size.height, 800))
            )
            
            // Twinkling animation
            let fadeOut = SKAction.fadeAlpha(to: 0.05, duration: Double.random(in: 1.5...3.0))
            let fadeIn = SKAction.fadeAlpha(to: CGFloat.random(in: 0.2...0.4), duration: Double.random(in: 1.5...3.0))
            star.run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
            
            particleNode.addChild(star)
        }
        
        addChild(particleNode)
    }
    
    // MARK: - Element Spawning
    
    /// Spawns an element at the top of the scene with a slight random horizontal offset.
    func spawnElement(_ element: Element) {
        let xOffset = CGFloat.random(in: -80...80)
        let spawnX = size.width / 2 + xOffset
        let spawnY = size.height - 80
        let position = CGPoint(x: spawnX, y: spawnY)
        
        let node = createElementNode(element: element, position: position)
        addChild(node)
        elementNodes.insert(node)
        
        // Spawn animation — scale from zero with a bounce
        node.setScale(0)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.3)
        scaleUp.timingMode = .easeOut
        node.run(scaleUp)
    }
    
    // MARK: - Node Creation
    
    /// Creates an element physics node with visual styling and physics body.
    private func createElementNode(element: Element, position: CGPoint) -> SKShapeNode {
        let node = SKShapeNode(circleOfRadius: element.radius)
        node.position = position
        node.name = "element_\(element.symbol)"
        node.fillColor = element.color
        node.strokeColor = element.color.withAlphaComponent(0.6)
        node.lineWidth = 2.0
        node.glowWidth = 4.0
        
        // Element symbol label
        let label = SKLabelNode(text: element.symbol)
        label.fontName = "Avenir-Heavy"
        label.fontSize = element.radius * 0.85
        label.fontColor = element == .hydrogen || element == .helium || element == .neon
            ? SKColor.darkGray
            : SKColor.white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.name = "label"
        node.addChild(label)
        
        // Physics body
        let body = SKPhysicsBody(circleOfRadius: element.radius)
        body.mass = element.mass * 0.01 // Scale down mass for reasonable physics
        body.restitution = 0.3          // Lower bounciness
        body.friction = 0.6
        body.linearDamping = 2.0        // Higher damping to settle faster
        body.angularDamping = 2.0
        body.categoryBitMask = PhysicsCategory.element
        body.contactTestBitMask = PhysicsCategory.element | PhysicsCategory.molecule
        body.collisionBitMask = PhysicsCategory.element | PhysicsCategory.boundary | PhysicsCategory.molecule
        node.physicsBody = body
        
        // Store element data in userData for retrieval during collisions
        node.userData = NSMutableDictionary()
        node.userData?["element"] = element.rawValue
        node.userData?["components"] = [element: 1]
        
        return node
    }
    
    /// Creates a molecule node after successful fusion.
    private func createMoleculeNode(molecule: Molecule, position: CGPoint) -> SKShapeNode {
        // Outer ring
        let node = SKShapeNode(circleOfRadius: molecule.radius)
        node.position = position
        node.name = "molecule_\(molecule.formula)"
        node.fillColor = molecule.color.withAlphaComponent(0.85)
        node.strokeColor = molecule.color
        node.lineWidth = 3.0
        node.glowWidth = 8.0
        
        // Inner ring for visual distinction
        let innerRing = SKShapeNode(circleOfRadius: molecule.radius * 0.7)
        innerRing.fillColor = molecule.color.withAlphaComponent(0.4)
        innerRing.strokeColor = molecule.color.withAlphaComponent(0.6)
        innerRing.lineWidth = 1.5
        node.addChild(innerRing)
        
        // Molecule formula label
        let label = SKLabelNode(text: molecule.formula)
        label.fontName = "Avenir-Heavy"
        label.fontSize = molecule.radius * 0.55
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.name = "label"
        node.addChild(label)
        
        // Molecule name label (smaller, below formula)
        let nameLabel = SKLabelNode(text: molecule.name)
        nameLabel.fontName = "Avenir-Medium"
        nameLabel.fontSize = molecule.radius * 0.3
        nameLabel.fontColor = SKColor.white.withAlphaComponent(0.7)
        nameLabel.verticalAlignmentMode = .top
        nameLabel.horizontalAlignmentMode = .center
        nameLabel.position = CGPoint(x: 0, y: -molecule.radius * 0.35)
        node.addChild(nameLabel)
        
        // Physics body
        let body = SKPhysicsBody(circleOfRadius: molecule.radius)
        let totalMass = molecule.components.reduce(CGFloat(0)) { $0 + ($1.key.mass * CGFloat($1.value)) }
        body.mass = totalMass * 0.01
        body.restitution = 0.2
        body.friction = 0.7
        body.linearDamping = 0.3
        body.angularDamping = 0.3
        body.categoryBitMask = PhysicsCategory.molecule
        body.contactTestBitMask = PhysicsCategory.element | PhysicsCategory.molecule
        body.collisionBitMask = PhysicsCategory.element | PhysicsCategory.boundary | PhysicsCategory.molecule
        node.physicsBody = body
        
        node.userData = NSMutableDictionary()
        node.userData?["components"] = molecule.components
        
        return node
    }
    
    // MARK: - Touch / Mouse Handling (Drag & Drop)
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        handleInteractionBegan(at: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        handleInteractionMoved(to: location)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleInteractionEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleInteractionEnded()
    }
    
    #elseif os(macOS)
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        handleInteractionBegan(at: location)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let location = event.location(in: self)
        handleInteractionMoved(to: location)
    }
    
    override func mouseUp(with event: NSEvent) {
        handleInteractionEnded()
    }
    #endif
    
    // MARK: - Shared Interaction Logic
    
    private func handleInteractionBegan(at location: CGPoint) {
        let touchedNode = atPoint(location)
        
        if let elementNode = findDraggableParent(of: touchedNode) {
            selectedNode = elementNode
            // Disable physics while dragging
            elementNode.physicsBody?.isDynamic = false
            
            // Visual feedback — slight scale up
            elementNode.run(SKAction.scale(to: 1.15, duration: 0.1))
        }
    }
    
    private func handleInteractionMoved(to location: CGPoint) {
        guard let node = selectedNode else { return }
        node.position = location
    }
    
    private func handleInteractionEnded() {
        guard let node = selectedNode else { return }
        
        // Re-enable physics
        node.physicsBody?.isDynamic = true
        node.physicsBody?.velocity = .zero
        
        // Reset scale
        node.run(SKAction.scale(to: 1.0, duration: 0.1))
        
        selectedNode = nil
    }
    
    /// Walks up the node hierarchy to find a draggable element or molecule node.
    private func findDraggableParent(of node: SKNode) -> SKNode? {
        var current: SKNode? = node
        while let n = current {
            if let name = n.name, name.hasPrefix("element_") || name.hasPrefix("molecule_") {
                return n
            }
            current = n.parent
        }
        return nil
    }
    
    // MARK: - Collision Detection
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        guard let a = nodeA, let b = nodeB, a.parent != nil, b.parent != nil else { return }
        
        // Ignore dragging nodes
        if a == selectedNode || b == selectedNode { return }
        
        // Ensure both are reactable (element or molecule)
        let isAReactable = (a.name?.hasPrefix("element_") == true || a.name?.hasPrefix("molecule_") == true)
        let isBReactable = (b.name?.hasPrefix("element_") == true || b.name?.hasPrefix("molecule_") == true)
        guard isAReactable && isBReactable else { return }
        
        let componentsA = a.userData?["components"] as? [Element: Int] ?? [:]
        let componentsB = b.userData?["components"] as? [Element: Int] ?? [:]
        
        // Combine components
        var combined = componentsA
        for (el, count) in componentsB {
            combined[el, default: 0] += count
        }
        
        let key = ReactionManager.shared.generateKey(components: combined)
        
        let midPoint = CGPoint(
            x: (a.position.x + b.position.x) / 2,
            y: (a.position.y + b.position.y) / 2
        )
        
        if let molecule = ReactionManager.shared.reactions[key] {
            // Fusion Match
            performFusion(molecule: molecule, involvedNodes: [a, b], at: midPoint)
        } else {
            // No Match: Repel
            repelNodes(a, b, componentsA: componentsA, componentsB: componentsB)
        }
    }
    
    private func repelNodes(_ a: SKNode, _ b: SKNode, componentsA: [Element: Int], componentsB: [Element: Int]) {
        guard let bodyA = a.physicsBody, let bodyB = b.physicsBody else { return }
        
        // Calculate restitution based on Noble Gases
        let isANoble = componentsA.keys.contains { $0 == .helium || $0 == .neon }
        let isBNoble = componentsB.keys.contains { $0 == .helium || $0 == .neon }
        let restitutionA: CGFloat = isANoble ? 1.0 : 0.5
        let restitutionB: CGFloat = isBNoble ? 1.0 : 0.5
        
        // Apply immediate impulse to push apart
        let dx = a.position.x - b.position.x
        let dy = a.position.y - b.position.y
        let distance = max(hypot(dx, dy), 1.0)
        
        let nx = dx / distance
        let ny = dy / distance
        
        let baseForce: CGFloat = 6.0
        
        bodyA.applyImpulse(CGVector(dx: nx * baseForce * restitutionA, dy: ny * baseForce * restitutionA))
        bodyB.applyImpulse(CGVector(dx: -nx * baseForce * restitutionB, dy: -ny * baseForce * restitutionB))
    }
    
    /// Performs the fusion: removes element nodes and spawns a molecule node.
    private func performFusion(molecule: Molecule, involvedNodes: [SKNode], at position: CGPoint) {
        // Remove involved element nodes
        for node in involvedNodes {
            elementNodes.remove(node)
            
            // Shrink animation before removal
            let shrink = SKAction.scale(to: 0, duration: 0.1)
            let remove = SKAction.removeFromParent()
            node.run(SKAction.sequence([shrink, remove]))
            
            // Avoid duplicate contacts
            node.physicsBody?.contactTestBitMask = PhysicsCategory.none
            node.physicsBody?.collisionBitMask = PhysicsCategory.none
        }
        
        // Spawn molecule after a brief delay
        let wait = SKAction.wait(forDuration: 0.15)
        run(wait) { [weak self] in
            guard let self = self else { return }
            
            let moleculeNode = self.createMoleculeNode(molecule: molecule, position: position)
            self.addChild(moleculeNode)
            
            // Spawn animation
            moleculeNode.setScale(0)
            let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.15)
            moleculeNode.run(SKAction.sequence([scaleUp, scaleDown]))
            
            // Fusion particle burst effect
            self.addFusionEffect(at: position, color: molecule.color)
            
            self.onMoleculeCreated?()
        }
    }
    
    /// Creates a burst particle effect at the fusion point.
    private func addFusionEffect(at position: CGPoint, color: SKColor) {
        let burstCount = 12
        
        for i in 0..<burstCount {
            let particle = SKShapeNode(circleOfRadius: 3)
            particle.fillColor = color
            particle.strokeColor = .clear
            particle.position = position
            particle.zPosition = 10
            addChild(particle)
            
            let angle = (CGFloat(i) / CGFloat(burstCount)) * .pi * 2
            let distance: CGFloat = 50
            let destination = CGPoint(
                x: position.x + cos(angle) * distance,
                y: position.y + sin(angle) * distance
            )
            
            let move = SKAction.move(to: destination, duration: 0.4)
            move.timingMode = .easeOut
            let fade = SKAction.fadeOut(withDuration: 0.4)
            let group = SKAction.group([move, fade])
            let remove = SKAction.removeFromParent()
            
            particle.run(SKAction.sequence([group, remove]))
        }
        
        // Central flash
        let flash = SKShapeNode(circleOfRadius: 20)
        flash.fillColor = .white
        flash.strokeColor = .clear
        flash.position = position
        flash.alpha = 0.8
        flash.zPosition = 9
        addChild(flash)
        
        let expand = SKAction.scale(to: 2.5, duration: 0.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let group = SKAction.group([expand, fadeOut])
        flash.run(SKAction.sequence([group, .removeFromParent()]))
    }
    
    // MARK: - Canvas Management
    
    /// Removes all element and molecule nodes from the scene.
    func clearAllNodes() {
        for node in elementNodes {
            node.removeFromParent()
        }
        elementNodes.removeAll()
        
        // Also remove molecules
        self.children
            .filter { $0.name?.hasPrefix("molecule_") == true }
            .forEach { $0.removeFromParent() }
    }
    
}
