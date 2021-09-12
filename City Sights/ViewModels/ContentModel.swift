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
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        switch category {
                            case Constants.sightsKey:
                                self.sights = result.businesses
                            case Constants.restaurantsKey:
                                self.restaurants = result.businesses
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
