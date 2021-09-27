//
//  OnboardingView.swift
//  City Sights
//
//  Created by wizz on 9/26/21.
//

import SwiftUI

struct OnboardingView: View {
    
    
    @EnvironmentObject var model: ContentModel
    @State private var tabSelection = 0
    
    private let blue = Color(red: 0/255, green: 130/255, blue: 167/255)
    private let turquoise = Color(red: 55/255, green: 197/255, blue: 192/255)
    var body: some View {
        VStack{
            //Tab View
            TabView(selection: $tabSelection) {
                    //First tab
                VStack(spacing: 20){
                    Image("city2")
                        .resizable()
                        .scaledToFit()
                    Text("Welcome to city Sights!")
                        .bold()
                        .font(.title)
                    Text("City Sights helps you find the best of the city!")
                        
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .tag(0)
                
                //Second tab
                VStack(spacing: 20){
                    Image("city1")
                        .resizable()
                        .scaledToFit()
                    Text("Ready to discover your city")
                        .bold()
                        .font(.title)
                    Text("We'll show you the best restaurants, venues and more, based on your location!")
                        
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .tag(1)
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            Button {
                if tabSelection == 0 {
                    tabSelection = 1
                }else{
                    //Request for geolocation permission
                    model.requestGeolocationPermission()
                }
            } label: {
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .cornerRadius(10)
                    Text(tabSelection == 0 ? "Next" : "Get My Location")
                }
            }
            .padding()
            .accentColor(tabSelection == 0 ? blue : turquoise)
            
            Spacer()
        }
        .background(tabSelection == 0 ? blue : turquoise)
        .ignoresSafeArea()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
