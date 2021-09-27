//
//  ContentView.swift
//  City Sights
//
//  Created by wizz on 9/5/21.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    var body: some View {
        
        //Detect the authorization status of geolocating the user
        if model.authorizationState == .notDetermined {
            //If undetermenind show onboarding
            OnboardingView()
        }else if model.authorizationState == .authorizedAlways || model.authorizationState == .authorizedWhenInUse {
            
            //if approved , show home voiew
            HomeView()
        }else{
            //if denied show denied view
            LocationDeniedView()
        }
 
       
   
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(ContentModel())
    }
}
