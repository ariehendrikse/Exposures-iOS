//
//  MapView.swift
//  CovidNearMe (iOS)
//
//  Created by Arie Hendrikse on 18/2/21.
//

import SwiftUI
import MapKit
import UIKit

struct MapView: UIViewRepresentable {
    //@Binding var route: MKPolyline? = MKPolyline()
    @Binding var locations: [Annotatable]
    @Binding var regionBinding: MKCoordinateRegion
    @Binding var findLocation: Bool
    @Binding var isActive: Bool
    @Binding var selectedAnnotation: KenExposure?
    @Binding var didChange: Bool

    
    func makeUIView(context: Context) -> MKMapView {
        let x = MKMapView(frame: .zero)
        x.showsUserLocation = true
        x.delegate = context.coordinator
        return x
    }
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
    }

    

    func updateUIView(_ view: MKMapView, context: Context) {
        view.translatesAutoresizingMaskIntoConstraints = false   // (2) In the absence of this, we get constraints error on rotation; and again, it seems one should do this in makeUIView, but has to be here
        if findLocation {
            view.setUserTrackingMode(.follow, animated: false)
            findLocation = false
        }
        else {
            view.setUserTrackingMode(.none, animated: false)
        }


        //addRoute(to: view)
        if didChange  {
//            view.setUserTrackingMode(.none, animated: false)
            addLocation(to: view)
            addLocationOverlay(to: view)
            didChange = false
        }
    }
    
}

private extension MapView {
//    func addRoute(to view: MKMapView) {
//        if !view.overlays.isEmpty {
//            view.removeOverlays(view.overlays)
//        }
//
//        guard let route = route else { return }
//        let mapRect = route.boundingMapRect
//        view.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)
//        view.addOverlay(route)
//    }
    func addLocation(to view: MKMapView) {


        if !view.annotations.isEmpty {
            view.removeAnnotations(view.annotations)
        }
        let annotations = locations.map { (loc0) -> MKAnnotation in
            loc0.customAnnotation
        }
        view.addAnnotations(annotations)
    }

    func addLocationOverlay(to view: MKMapView) {
        if !view.overlays.isEmpty {
            view.removeOverlays(view.overlays)
        }
        locations.forEach({ (loc0) in
            if let annot = loc0 as? MonitorLocation {
                let circle = MKCircle(center: annot.locationCoordinate, radius: CLLocationDistance(annot.radius!))
                view.addOverlay(circle)
            }
//            print(view.center)
//            print(view.userLocation.coordinate)

        })
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        parent.regionBinding = mapView.region
    }
    
    var lastSelectedPin: MKAnnotationView?


    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
          let renderer = MKCircleRenderer(overlay: overlay)
          renderer.fillColor = UIColor.systemPurple.withAlphaComponent(0.3)
            renderer.strokeColor = UIColor.systemPurple.withAlphaComponent(0.9)
          renderer.lineWidth = 1
          return renderer
        }
        let polyLine = MKPolylineRenderer.init(overlay: overlay)
        polyLine.strokeColor = UIColor.green
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
//        renderer.strokeColor = UIColor.red.withAlphaComponent(0.8)
//        return renderer
        return polyLine
      }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView =
            MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier:
                    String(annotation.coordinate.latitude) + String(annotation.coordinate.longitude) + String(((annotation.title) ?? "salt") ?? "no title"
                )
        )
        if let clinicAnnotion = annotation as? CustomAnnotation {
            annotationView.markerTintColor = clinicAnnotion.color
            annotationView.glyphImage = clinicAnnotion.image
            annotationView.displayPriority = MKFeatureDisplayPriority.required
            annotationView.zPriority = MKAnnotationViewZPriority(rawValue: MKAnnotationViewZPriority.RawValue(clinicAnnotion.priority))
        }
        if annotation.title! == "My Location" {
            annotationView.markerTintColor = .systemGreen
        }
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.lastSelectedPin = view
        guard let annotation = view.annotation as? CustomAnnotation else {return }
        if let exposure = annotation.ken {
            parent.isActive = true
            parent.selectedAnnotation = exposure
        }
    }
}

