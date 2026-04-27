//
//  ElementDrawerView.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import SwiftUI

// MARK: - Element Drawer View
/// A bottom-docked horizontal scroll view containing tappable element buttons.
/// Each button spawns the corresponding element in the physics sandbox.
struct ElementDrawerView: View {
    
    /// Reference to the sandbox view model for spawning elements
    var viewModel: SandboxViewModel
    
    /// Tracks the last tapped element for haptic/visual feedback
    @State private var lastTapped: Element?
    
    var body: some View {
        VStack(spacing: 8) {
            // Drawer handle indicator
            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            // Element buttons scroll view
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(Element.allCases) { element in
                        ElementButton(
                            element: element,
                            isActive: lastTapped == element
                        ) {
                            spawnElement(element)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .scrollIndicators(.hidden)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        )
        .padding(.horizontal, 8)
        .padding(.bottom, 4)
    }
    
    /// Spawn element and trigger feedback
    private func spawnElement(_ element: Element) {
        lastTapped = element
        viewModel.spawnElement(element)
        
        // Reset active state after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if lastTapped == element {
                lastTapped = nil
            }
        }
    }
}

// MARK: - Element Button
/// Individual element button with CPK color, symbol, and atomic number.
struct ElementButton: View {
    let element: Element
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                // Element circle
                ZStack {
                    // Glow ring
                    Circle()
                        .fill(element.swiftUIColor.opacity(0.3))
                        .frame(width: 54, height: 54)
                    
                    // Main circle
                    Circle()
                        .fill(element.swiftUIColor.gradient)
                        .frame(width: 46, height: 46)
                    
                    // Symbol
                    Text(element.symbol)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(
                            element == .hydrogen || element == .helium || element == .neon || element == .beryllium
                            ? .black.opacity(0.8)
                            : .white
                        )
                }
                .scaleEffect(isActive ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isActive)
                
                // Atomic number
                Text("\(element.atomicNumber)")
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .buttonStyle(.plain)
        #if os(iOS)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isActive)
        #endif
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            Spacer()
            ElementDrawerView(viewModel: SandboxViewModel())
        }
    }
}
