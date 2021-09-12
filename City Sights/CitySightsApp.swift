//
//  CitySightsApp.swift
//  City Sights
//
//  Created by wizz on 9/5/21.
//

import SwiftUI

@main
struct CitySightsApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
