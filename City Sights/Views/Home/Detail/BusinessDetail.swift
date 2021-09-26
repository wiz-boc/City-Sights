//
//  BusinessDetail.swift
//  City Sights
//
//  Created by wizz on 9/26/21.
//

import SwiftUI

struct BusinessDetail: View {
    
    var business: Business
    var body: some View {
        VStack(alignment: .leading){
            
            VStack(alignment: .leading, spacing: 0){
                
                GeometryReader(){ geometry in
                    //Business image
                    let uiImage = UIImage(data: business.imageData ?? Data())
                    Image(uiImage: uiImage ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        
                }.ignoresSafeArea(.all, edges: .top)
                
                //Open / close indicator
                ZStack(alignment:.leading){
                    Rectangle()
                        .frame(height: 36)
                        .foregroundColor(business.isClosed! ? .gray : .blue)
                    
                    Text(business.isClosed! ? "Closed" : "Open")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.leading)
                }
                
            }
            
            
            
            Group{
                //Business Name
                Text(business.name!)
                    .font(.largeTitle)
                    .padding()
                //loop through display Address
                
                if business.location?.displayAddress != nil {
                    ForEach(business.location!.displayAddress!, id: \.self){ displayLine in
                        Text(displayLine)
                            .padding(.horizontal)
                    }
                }
                //Rading
                Image("regular_\(business.rating ?? 0)")
                    .padding()
                
                Divider()
                
                //Phone
                HStack{
                    Text("Phone:")
                        .bold()
                    Text(business.displayPhone ?? "")
                    Spacer()
                    Link("Call", destination: URL(string: "tel:\(business.phone ?? "")")!)
                }
                .padding()
                
                //Reviews
                HStack{
                    Text("Reviews:")
                        .bold()
                    Text(String(business.reviewCount ?? 0))
                    Spacer()
                    Link("Read", destination: URL(string: "\(business.url ?? "")")!)
                }.padding()
                
                Divider()
                
                //Website
                HStack{
                    Text("Website:")
                        .bold()
                    Text(business.url ?? "")
                        .lineLimit(1)
                    Spacer()
                    Link("Read", destination: URL(string: "\(business.url ?? "")")!)
                }.padding()
                
                
                Divider()
            }
            //Get direction buttons
            Button(action: {
                //TODO
            }) {
                ZStack{
                    Rectangle()
                        .frame(height: 48)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    
                    Text("Get Directions")
                        .foregroundColor(.white)
                        .bold()
                }
            }.padding()
        }
    }
}

//struct BusinessDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        BusinessDetail(business: <#T##Business#>)
//    }
//}
