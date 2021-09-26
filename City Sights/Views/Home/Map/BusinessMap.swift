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
}
