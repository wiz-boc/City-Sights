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
    
    var body: some View {
        if model.restaurants.count != 0 || model.sights.count != 0 {
            //Determine if we should show list or map
            if !isMapShowing {
                VStack(alignment: .center){
                    HStack{
                        Image(systemName: "location")
                        Text("San Francisco")
                        Spacer()
                        Text("Switch to map view")
                    }
                    Divider()
                    BusinessList()
                }
            }else{
                
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
