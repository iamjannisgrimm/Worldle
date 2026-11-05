# Worldle

A daily city-location guessing game built with SwiftUI and MapKit. Read the city name, explore the globe and place a pin where you think it belongs. The app grades the guess by distance, country and continent.

This repository contains the app, its shared Xcode scheme and a simulator smoke test. No game account or project-specific API key is required.

## Requirements

The checked-in [Xcode project](Worldle.xcodeproj) targets **iOS 26.0**. Use a Mac with full Xcode capable of building that target, plus a compatible simulator runtime or physical device. The simulator helper also requires Python 3. MapKit imagery and reverse geocoding may use Apple services.

The older [source README](Worldle/README.md) says iOS 16; that platform claim is historical. Use the project settings and [test profile](config/testing.json) for current build and simulator requirements.
