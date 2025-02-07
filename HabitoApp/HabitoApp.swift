//
//  HabitoApp.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/4/25.
//

import SwiftUI

@main
struct HabitoApp: App {

    init() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.customSecondary
        appearance.shadowColor = nil

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white

    }


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
