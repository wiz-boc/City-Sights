//
//  DirectionsView.swift
//  City Sights
//
//  Created by wizz on 9/26/21.
//

import SwiftUI

struct DirectionsView: View {
    
    var business: Business
    var body: some View {
        VStack(alignment: .leading){
            
            HStack{
                BusinessTitle(business: business)
                Spacer()
                
                if let lat = business.coordinates?.latitude,
                   let long = business.coordinates?.longitude,
                   let name = business.name{
                    Link("Open in maps", destination: URL(string: "http://maps.apple.com/?ll=\(lat),\(long)&q=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!)
                
                }
            }
            .padding()
            DirectionsMap(business: business)
                .ignoresSafeArea(.all,edges: .bottom)
            
        }
    }
}

//struct DirectionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DirectionsView()
//    }
//}
