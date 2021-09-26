//
//  BusinessSection.swift
//  City Sights
//
//  Created by wizz on 9/16/21.
//

import SwiftUI

struct BusinessSection: View {
    var title: String
    var businesses: [Business]
    var body: some View {
        Section(header: BusinessSectionHeader(title: title)){
            ForEach(businesses){ business in
                NavigationLink(destination: BusinessDetail(business: business)){
                    BusinessRow(business: business)
                }
            }
        }
    }
}

struct BusinessSection_Previews: PreviewProvider {
    static var previews: some View {
        BusinessSection(title: "Sights", businesses: [])
    }
}
