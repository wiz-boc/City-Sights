//
//  ContentModel.swift
//  City Sights
//
//  Created by wizz on 9/9/21.
//

import Foundation
import CoreLocation

class ContentModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    override init() {
        super.init()
        //Set content model as the delegate of the location manager
        locationManager.delegate = self
        //Request permission from the user
        locationManager.requestWhenInUseAuthorization()
        
        //TODL Start geolocating the user, after we get permission
        //locationManager.startUpdatingLocation()
    }
    
    //MARK - Location Manager Delegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == CLAuthorizationStatus.authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse {
            //We have permission
            //Start geolocation the user after we get permission
            locationManager.startUpdatingLocation()
        }else if locationManager.authorizationStatus == .denied {
            //We dont have permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Give us the location of the user
        let userLocation = locations.first
        
        if userLocation != nil {
            locationManager.stopUpdatingLocation()
            //TODO: if we have coordinates of user , send into Yelp API
            getBusinesses(for: "arts", location: userLocation!)
            getBusinesses(for: "restaurants", location: userLocation!)
        }
    }
    
    //MARK:- Yelp API Methos
    
    func getBusinesses(for category:String, location:CLLocation){
        //Create URL
       // let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.latitude)&categories=\(category)&limit=6"
        var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.addValue("Bearer Pss7PkHamY58vJHJVfPFm18Z04vIjxu0c32pjTzKz_XGWiLD82xqeceP4I-K4RfsjnaJCalHVdvDKUgp57zR-07Iv9f3I-xIu80FgkRMO0obYsOOpgswmdbthj89YXYx", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request){ (data, response, error) in
            if error == nil {
                print(response)
            }else{
                print(error)
            }
        }
        dataTask.resume()
    }
}
