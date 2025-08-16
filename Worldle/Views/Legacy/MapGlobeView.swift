import SwiftUI
import MapKit
import CoreLocation

struct MapGlobeView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var isPinPlaced: Bool
    let targetCity: City
    
    @State private var position: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            distance: 45_000_000,
            heading: 0,
            pitch: 0
        )
    )
    
    @State private var guessAnnotation: GuessAnnotation?
    
    var body: some View {
        Map(position: $position, interactionModes: .all) {
            if let annotation = guessAnnotation {
                Annotation("Your Guess", coordinate: annotation.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                        .background(Circle().fill(.white).scaleEffect(0.8))
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }
        .onTapGesture { location in
            // This won't work directly - we need to convert screen coordinates to map coordinates
            // We'll use the UIViewRepresentable approach instead
        }
        .onChange(of: isPinPlaced) { oldValue, newValue in
            if !newValue {
                guessAnnotation = nil
            }
        }
    }
}

struct GuessAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}