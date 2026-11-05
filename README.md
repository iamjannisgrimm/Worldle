# Worldle

A daily city-location guessing game built with SwiftUI and MapKit. Read the city name, explore the globe and place a pin where you think it belongs. The app grades the guess by distance, country and continent.

This repository contains the app, its shared Xcode scheme and a simulator smoke test. No game account or project-specific API key is required.

## Requirements

The checked-in [Xcode project](Worldle.xcodeproj) targets **iOS 26.0**. Use a Mac with full Xcode capable of building that target, plus a compatible simulator runtime or physical device. The simulator helper also requires Python 3. MapKit imagery and reverse geocoding may use Apple services.

The older [source README](Worldle/README.md) says iOS 16; that platform claim is historical. Use the project settings and [test profile](config/testing.json) for current build and simulator requirements.

## Quick start

1. Open [Worldle.xcodeproj](Worldle.xcodeproj) in Xcode.
2. Select the **Worldle** scheme and an iOS 26 simulator, then Run.
3. Read **Today’s City**, tap a location on the globe and choose **Confirm Guess**.

For physical-device development, select your development team in Signing & Capabilities before running on the connected device. Simulator checks use the dedicated device described below; signing and App Store distribution are separate release work.

## Playing

### Make a guess

The city heading gives the target name; the map is where you choose its location. A tap places a red **Your Guess** pin. Tap elsewhere to replace it before submitting. **Confirm Guess** appears once a pin is placed and the daily challenge is available.

Confirmation calculates the distance to the target coordinates and then determines the score category. Country/continent lookup is asynchronous, so the result may take longer when geocoding is needed.

### Globe controls

The active [RealGlobeView](Worldle/Views/Components/RealGlobeView.swift) wraps an `MKMapView` using satellite flyover imagery. Pan and zoom to explore; rotation and pitch are enabled, with a compass and scale. The map does not show or track the player’s current location.

The visible pin is the selected guess. The target city is not added as a map annotation by this view, and starting another test round clears the previous pin.

### Daily challenge

[DailyCityService](Worldle/Services/DailyCityService.swift) deterministically selects a city from the bundled sample list using the number of calendar days since January 1, 2024. It uses `Calendar.current`, rather than a server clock or an explicit shared UTC rollover.

Normal play records one completed guess for the date and displays **You’ve played today!** afterward. A fresh view model loads that date’s city and play status. The current main view does not wire an automatic midnight refresh; do not assume a running session switches challenges at midnight.

### Score categories

Categories are checked in this order. Distances are calculated with Core Location and converted from meters to kilometers.

| Category | Condition | Points |
| --- | --- | ---: |
| Perfect! | At most 15 km from the target | 5,000 |
| Excellent! | More than 15 km and at most 100 km | 3,000 |
| Same Country | Outside those distances, with a matching country | 1,500 |
| Same Continent | No country match, with a matching continent | 500 |
| Miss | No earlier category matches | 100 |

Thresholds live in [Constants.swift](Worldle/Models/Constants.swift); labels and points live in [ScoreCategory.swift](Worldle/Models/ScoreCategory.swift).

### Geographic scoring and network access

[LocationService](Worldle/Services/LocationService.swift) awards the two distance categories before reverse geocoding. For farther guesses, it compares the returned country name case-insensitively with the target, then checks a country-to-continent table with approximate geographic bounds as a fallback.

Failed or unavailable geocoding falls through to **Miss**. Country naming, approximate continent boundaries and Apple service availability can therefore affect results. A Miss does not always establish that the player chose the wrong continent, and full offline play is not verified by the smoke test.

### Results

The result sheet displays the category title, its description and a target visualization. The model retains distance and points, but the current sheet does not display those numeric values. [ResultSheet](Worldle/Views/Components/ResultSheet.swift) and [TargetView](Worldle/Views/Components/TargetView.swift) own this presentation.

Normal play ends with **See you tomorrow!** Testing mode replaces that message with **Play Again**.

### Sharing

**Share Result** opens the native share sheet. Its payload is text containing the Worldle name, the current formatted date and a category-specific emoji target. It does not include the city name, guessed coordinates, numeric distance or points.

Opening the share sheet does not automatically send anything. The automated smoke test checks that the share button exists; it does not send a result or validate a sharing destination.

### Testing mode and replay

Tap the city heading once to toggle the app’s existing testing mode. It bypasses the daily lock without clearing stored play preferences. **Play Again** then resets the result and guess and selects a random city from the same sample list; a repeat city is possible.

Testing mode starts off in a new app process and is not persisted by the current view model. Turning it off rechecks the stored daily flag. This is existing app behavior, not a special launch argument added by the UI test.

### Saved play status

Normal completed guesses write a `UserDefaults` boolean under `played_yyyy-MM-dd`, using the date formatter in [Extensions.swift](Worldle/Models/Extensions.swift). Testing-mode guesses do not write that completion flag.

The current implementation stores daily completion, not a saved guess, score history or account-synced game. Relaunching can retain the daily lock without restoring the previous result sheet. Preserve those preferences when testing; the smoke flow uses testing mode instead of deleting player data.

## City data

[City.sampleCities](Worldle/Models/City.swift) is the active list of **24 cities**, each with a name, country, continent and coordinate. Both daily selection and random testing rounds use this Swift array. [Resources/cities.json](Worldle/Resources/cities.json) exists, but the current daily-city service does not load it.

Changing the array’s order or length changes the deterministic daily sequence. Review coordinates and country/continent strings together with the scoring service when maintaining this data.
