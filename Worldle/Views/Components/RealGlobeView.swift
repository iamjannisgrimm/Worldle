import SwiftUI
import MapKit
import CoreLocation

#if canImport(UIKit)
import UIKit

// MARK: - Real Globe View

/// UIKit-based MapKit globe implementation for interactive city guessing
struct RealGlobeView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var isPinPlaced: Bool
    let targetCity: City
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none
        
        // Use satellite flyover for true globe view
        mapView.mapType = .satelliteFlyover
        
        // Remove zoom restrictions to allow maximum zoom out
        mapView.setCameraZoomRange(nil, animated: false)
        
        // Set to maximum possible zoom out using coordinate region
        mapView.setRegion(Constants.UI.defaultMapRegion, animated: false)
        
        mapView.delegate = context.coordinator
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = context.coordinator
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.mapView = uiView
        
        if !isPinPlaced {
            uiView.removeAnnotations(uiView.annotations)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: RealGlobeView
        var mapView: MKMapView?
        
        init(_ parent: RealGlobeView) {
            self.parent = parent
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            // Only handle single taps, not during pan/zoom gestures
            return touch.tapCount == 1
        }
        
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard let mapView = mapView else { return }
            
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Your Guess"
            mapView.addAnnotation(annotation)
            
            parent.selectedCoordinate = coordinate
            parent.isPinPlaced = true
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "GuessPin"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            if let markerView = annotationView as? MKMarkerAnnotationView {
                markerView.markerTintColor = .systemRed
                markerView.animatesWhenAdded = true
            }
            
            return annotationView
        }
    }
}

#else

// MARK: - Fallback for non-iOS platforms

struct RealGlobeView: View {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var isPinPlaced: Bool
    let targetCity: City
    
    var body: some View {
        Text("Map view not available on this platform")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
    }
}

#endif