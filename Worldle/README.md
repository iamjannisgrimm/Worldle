# Worldle iOS App

A geography-based guessing game inspired by Wordle, built with SwiftUI and MapKit.

## Project Structure

```
Worldle/
├── App/                    # App configuration and entry point
│   └── WorldleApp.swift    # Main app file
├── Models/                 # Data models and state
│   ├── City.swift         # City model with coordinates
│   ├── GameState.swift    # Game state management
│   └── ScoreCategory.swift # Scoring system definitions
├── Services/              # Business logic and external services
│   ├── DailyCityService.swift # Daily city selection logic
│   └── LocationService.swift  # Location and geocoding services
├── ViewModels/            # MVVM view models
│   └── GameViewModel.swift # Main game logic controller
├── Views/                 # User interface components
│   ├── ContentView.swift  # Main game screen
│   ├── Components/        # Reusable UI components
│   │   ├── RealGlobeView.swift # MapKit globe implementation
│   │   ├── ResultSheet.swift   # Result display sheet
│   │   └── TargetView.swift    # Target visualization
│   └── Legacy/            # Deprecated/unused views
│       ├── MapGlobeView.swift
│       └── SwiftUIGlobeView.swift
└── Resources/             # Assets and data files
    ├── Assets.xcassets/   # App icons and images
    └── cities.json        # City data (if used)
```

## Architecture

This app follows the **MVVM (Model-View-ViewModel)** architecture pattern:

- **Models**: Pure data structures and state management
- **Views**: SwiftUI views for user interface
- **ViewModels**: Business logic and state management
- **Services**: External API interactions and business services

## Key Features

- 🌍 Interactive 3D globe using MapKit
- 🎯 Daily city guessing game
- 📱 Elegant SwiftUI interface
- 🎨 Beautiful target visualization for sharing
- 🧪 Testing mode for development
- 📊 Scoring system with multiple categories

## Technical Details

- **Platform**: iOS 16.0+
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Map Framework**: MapKit
- **Architecture**: MVVM with protocol-based services
- **Async**: Modern async/await patterns
- **State Management**: ObservableObject with @Published properties