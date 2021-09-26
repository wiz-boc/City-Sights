//
//  HomeView.swift
//  City Sights
//
//  Created by wizz on 9/16/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ContentModel
    @State var isMapShowing = false
    @State var selectedBusiness: Business?
    
    var body: some View {
        if model.restaurants.count != 0 || model.sights.count != 0 {
            NavigationView{
                //Determine if we should show list or map
                if !isMapShowing {
                    VStack(alignment: .center){
                        HStack{
                            Image(systemName: "location")
                            Text("San Francisco")
                            Spacer()
                            Button("Switch to map view") {
                                self.isMapShowing = true
                            }
                        }
                        Divider()
                        BusinessList()
                    }.padding([.horizontal,.top])
                        .navigationBarHidden(true)
                }else{
                    BusinessMap(selectedBusiness: $selectedBusiness)
                        .ignoresSafeArea()
                        .sheet(item: $selectedBusiness, content: {business in
                            BusinessDetail(business: business)
                        })
                }
            }
            
        }else{
            ProgressView()
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
