//
//  ContentView.swift
//  Worldle
//
//  Created by Jannis Grimm on 8/16/25.
//

import SwiftUI

// MARK: - Content View

/// Main view for the Worldle game
struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            // Full screen globe
            RealGlobeView(
                selectedCoordinate: Binding(
                    get: { viewModel.selectedCoordinate },
                    set: { coordinate in
                        if let coordinate = coordinate {
                            viewModel.updateSelectedCoordinate(coordinate)
                        }
                    }
                ),
                isPinPlaced: Binding(
                    get: { viewModel.isPinPlaced },
                    set: { _ in } // Read-only, controlled by ViewModel
                ),
                targetCity: viewModel.currentCity
            )
            
            // Overlay UI elements
            VStack {
                // Top overlay - City display
                VStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Text("Today's City")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.7))
                            .textCase(.uppercase)
                            .tracking(1.0)
                        
                        Text("\(viewModel.currentCity.name)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
                    .onTapGesture {
                        viewModel.toggleTestingMode()
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Bottom overlay - Action button only
                VStack(spacing: 16) {
                    if viewModel.hasPlayedToday {
                        VStack(spacing: 12) {
                            Text("🎯 You've played today!")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.ultraThinMaterial)
                                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                                )
                            
                            Text("Come back tomorrow for a new challenge!")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    } else if viewModel.isPinPlaced {
                        Button(action: {
                            viewModel.submitGuess()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Confirm Guess")
                                    .fontWeight(.semibold)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .blue.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        .scaleEffect(viewModel.isPinPlaced ? 1.0 : 0.8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.isPinPlaced)
                    }
                }
                .padding(.bottom, 40)
                .padding(.horizontal, 20)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: Binding(
            get: { viewModel.showResult },
            set: { viewModel.showResult = $0 }
        )) {
            ResultSheet(
                distance: viewModel.distance,
                score: viewModel.score,
                cityName: viewModel.currentCity.name,
                scoreCategory: viewModel.scoreCategory,
                viewModel: viewModel
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
