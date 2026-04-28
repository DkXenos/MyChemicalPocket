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
    @State private var showElementPicker = true
    
    var body: some View {
        ZStack {
            // SpriteKit physics sandbox (full screen)
            SpriteView(scene: viewModel.scene)
                .ignoresSafeArea()
            
            // UI overlay: Top Bar avoiding Dynamic Island
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    topBar
                        .padding(.top, max(geometry.safeAreaInsets.top, 16))
                    Spacer()
                }
            }
            .ignoresSafeArea(.container, edges: .top)
            .zIndex(1)
        }
        .sheet(isPresented: $showElementPicker) {
            ElementPickerView(viewModel: viewModel)
                .presentationDetents([.height(150), .medium])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .interactiveDismissDisabled(false)
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
            
            // Action Buttons
            HStack(spacing: 12) {
                // Add element button
                Button {
                    showElementPicker.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.green.opacity(0.8))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                )
                
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
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
