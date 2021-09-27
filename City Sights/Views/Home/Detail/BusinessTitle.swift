//
//  BusinessTitle.swift
//  City Sights
//
//  Created by wizz on 9/26/21.
//

import SwiftUI

struct BusinessTitle: View {
    var business: Business
    var body: some View {
        VStack(alignment: .leading){
        //Business Name
        Text(business.name!)
            .font(.title2)
            .bold()

        //loop through display Address
        
        if business.location?.displayAddress != nil {
            ForEach(business.location!.displayAddress!, id: \.self){ displayLine in
                Text(displayLine)
            }
        }
        //Rading
        Image("regular_\(business.rating ?? 0)")
        }
    }
}

//struct BusinessTitle_Previews: PreviewProvider {
//    static var previews: some View {
//        BusinessTitle()
//    }
//}
