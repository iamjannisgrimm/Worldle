import SwiftUI
import MapKit
import CoreLocation

struct SwiftUIGlobeView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var isPinPlaced: Bool
    let targetCity: City
    
    @State private var position: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            distance: 70_000_000,
            heading: 0,
            pitch: 0
        )
    )
    
    @State private var guessLocation: CLLocationCoordinate2D?
    
    var body: some View {
        ZStack {
            Map(position: $position, interactionModes: .all) {
                if let location = guessLocation {
                    Annotation("Your Guess", coordinate: location) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 24, height: 24)
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                    }
                }
            }
            .mapStyle(.imagery(elevation: .realistic))
            .mapControls {
                MapCompass()
                MapPitchToggle() 
                MapScaleView()
            }
            .onTapGesture(coordinateSpace: .global) { location in
                // SwiftUI Map doesn't easily provide coordinate conversion
                // We need to use the UIKit approach for precise tap-to-coordinate
            }
            
            // Invisible overlay to capture taps
            GlobeInteractionOverlay(
                selectedCoordinate: $selectedCoordinate,
                isPinPlaced: $isPinPlaced,
                guessLocation: $guessLocation
            )
        }
        .onAppear {
            // Force globe view with maximum distance
            position = .camera(
                MapCamera(
                    centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                    distance: 100_000_000,
                    heading: 0,
                    pitch: 0
                )
            )
        }
        .onChange(of: isPinPlaced) { oldValue, newValue in
            if !newValue {
                guessLocation = nil
            }
        }
    }
}

struct GlobeInteractionOverlay: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var isPinPlaced: Bool
    @Binding var guessLocation: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.parent = self
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: GlobeInteractionOverlay
        
        init(_ parent: GlobeInteractionOverlay) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            
            // For SwiftUI Map, we'll need to estimate coordinates
            // This is a simplified approach - in production you'd want more precise conversion
            if let view = gestureRecognizer.view {
                let normalizedX = location.x / view.bounds.width
                let normalizedY = location.y / view.bounds.height
                
                // Convert screen coordinates to approximate world coordinates
                let longitude = (normalizedX - 0.5) * 360
                let latitude = (0.5 - normalizedY) * 180
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                parent.selectedCoordinate = coordinate
                parent.isPinPlaced = true
                parent.guessLocation = coordinate
            }
        }
    }
}