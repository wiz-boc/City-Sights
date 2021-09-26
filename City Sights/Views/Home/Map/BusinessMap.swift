//
//  BusinessMap.swift
//  City Sights
//
//  Created by wizz on 9/26/21.
//

import SwiftUI
import MapKit

struct BusinessMap: UIViewRepresentable {
    
    @EnvironmentObject var model: ContentModel
    @Binding var selectedBusiness: Business?
    
    var locations:[MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        //Create a set of annotations for our list of businesses
        for business in model.restaurants + model.sights {
            
            //if the business has a lat/ling create an MKPoint Annotation
            if let lat = business.coordinates?.latitude,
               let long = business.coordinates?.longitude{
                //Create a new annotation
                let a = MKPointAnnotation()
                a.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                a.title = business.name ?? ""
                annotations.append(a)
            }
        }
        return annotations
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        //TODO: Set the region
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //Remove all annotations
        uiView.removeAnnotations(uiView.annotations)
        //Add the ones based on the business
        uiView.addAnnotations(self.locations)
        uiView.showAnnotations(self.locations, animated: true)
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeAnnotations(uiView.annotations)
    }
    
    //MARK:- Coordinator Class
    func makeCoordinator() -> Coordinator {
        return Coordinator(map: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var map: BusinessMap
        init(map: BusinessMap) {
            self.map = map
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            //Check if the annotation is the user
            if annotation is MKUserLocation {
                return nil
            }
            //Check if there's a reusbale annotation view first
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationReuseId)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationReuseId)
                
                //Create an annotation view
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }else{
                annotationView!.annotation = annotation
            }
            
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            //User tapped on the annotatatoon view
            
            //Get the business object that this annotation represents
            //Loop through businesses in the model and find a match
            for business in map.model.restaurants + map.model.sights {
                if business.name == view.annotation?.title {
                    map.selectedBusiness = business
                    return
                }
            }
        }
    }
    
}
