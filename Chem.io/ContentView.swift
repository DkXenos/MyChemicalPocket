//
//  ContentView.swift
//  Chem.io
//
//  Created by Jason TIo on 27/04/26.
//

import SwiftUI
import SpriteKit

// MARK: - Content View
/// Main view composing the SpriteKit physics sandbox with the SwiftUI element drawer.
struct ContentView: View {
    
    @State private var viewModel = SandboxViewModel()
    @State private var isDrawerOpen = false
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            // SpriteKit physics sandbox (full screen)
            SpriteView(scene: viewModel.scene)
                .ignoresSafeArea()
            
            // UI overlay: Top Bar
            VStack(spacing: 0) {
                topBar
                Spacer()
            }
            .zIndex(1)
            
            // Top element drawer
            VStack(spacing: 0) {
                ElementDrawerView(viewModel: viewModel)
                
                // Rope / Pull Handle
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color(white: 0.8))
                        .frame(width: 4, height: 60)
                    Circle()
                        .fill(Color(white: 0.8))
                        .frame(width: 16, height: 16)
                }
                .contentShape(Rectangle()) // Make it easily draggable
                .padding(.top, -4)
            }
            .offset(y: isDrawerOpen ? 0 : -150) // hide off-screen when closed
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        let translation = value.translation.height
                        if isDrawerOpen {
                            state = min(0, translation)
                        } else {
                            state = max(0, min(150, translation))
                        }
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 40
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            if isDrawerOpen {
                                if value.translation.height < -threshold {
                                    isDrawerOpen = false
                                }
                            } else {
                                if value.translation.height > threshold {
                                    isDrawerOpen = true
                                }
                            }
                        }
                    }
            )
            .zIndex(2)
        }
        #if os(iOS)
        .statusBarHidden(false)
        .persistentSystemOverlays(.hidden)
        #endif
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            // Molecule counter
            HStack(spacing: 6) {
                Image(systemName: "atom")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("\(viewModel.moleculesCreated)")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.3), value: viewModel.moleculesCreated)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
            )
            
            Spacer()
            
            // App title
            Text("My Chemical Pocket")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white.opacity(0.9), .white.opacity(0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Spacer()
            
            // Clear canvas button
            Button {
                viewModel.clearCanvas()
            } label: {
                Image(systemName: "trash.circle.fill")
                    .font(.system(size: 22))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.red.opacity(0.8))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
