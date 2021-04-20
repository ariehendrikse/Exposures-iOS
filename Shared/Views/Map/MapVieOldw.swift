////
////  MapView.swift
////  Landmarks
////
////  Created by Arie Hendrikse on 21/1/21.
////
//
//import SwiftUI
//import MapKit
//
//
//struct MapViewOld: UIViewRepresentable {
//    
//    var annotations: [ClinicAnnotation]
//    
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        return mapView
//    }
//
//    func updateUIView(_ view: MKMapView, context: Context) {
//        if annotations.count != view.annotations.count {
//            view.removeAnnotations(view.annotations)
//            view.addAnnotations(annotations)
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapView
//
//        init(_ parent: MapView) {
//            self.parent = parent
//        }
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            //parent.centerCoordinate = mapView.centerCoordinate
//        }
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
//            if let clinicAnnotion = annotation as? ClinicAnnotation {
//                annotationView.markerTintColor = clinicAnnotion.color
//                annotationView.glyphImage = clinicAnnotion.image
//            }
//
//            
//            annotationView.displayPriority = MKFeatureDisplayPriority.required
////            annotationView.zPriority = MKAnnotationViewZPriority(rawValue: MKAnnotationViewZPriority.RawValue(annotation.priority!))
//            return annotationView
//        }
//
//
//    }
//    @ObservedObject var locationViewModel = LocationViewModel()
//    
//}
