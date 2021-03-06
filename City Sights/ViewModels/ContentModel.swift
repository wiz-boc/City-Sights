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
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    @Published var placemark: CLPlacemark?
    
    override init() {
        super.init()
        //Set content model as the delegate of the location manager
        locationManager.delegate = self
       
        
        //TODL Start geolocating the user, after we get permission
        //locationManager.startUpdatingLocation()
    }
    
    func requestGeolocationPermission(){
        //Request permission from the user
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK - Location Manager Delegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        authorizationState = locationManager.authorizationStatus
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
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(userLocation!) { [self] placemarks, error in
                
                guard self == self else { return }
                if error == nil && placemarks != nil {
                    self.placemark = placemarks?.first
                }
            }
            
            getBusinesses(for: Constants.sightsKey, location: userLocation!)
            getBusinesses(for: Constants.restaurantsKey, location: userLocation!)
        }
    }
    
    //MARK:- Yelp API Methos
    
    func getBusinesses(for category:String, location:CLLocation){
        //Create URL
       // let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.latitude)&categories=\(category)&limit=6"
        var urlComponents = URLComponents(string: Constants.apiURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request){ (data, response, error) in
            if error == nil {
                
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(BusinessSearch.self, from: data!)
                    
                    //Sort business
                    var businesses = result.businesses
                    businesses.sort {(b1,b2) -> Bool in
                        return b1.distance ?? 0 < b2.distance ?? 0
                    }
                    
                    //Call get image func of the business
                    for b in businesses {
                        b.getImageData()
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        switch category {
                            case Constants.sightsKey:
                                self.sights = businesses
                            case Constants.restaurantsKey:
                                self.restaurants = businesses
                            default:
                                break
                        }
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
                
            }else{
                
            }
        }
        dataTask.resume()
    }
}
