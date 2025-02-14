//
//  CustomTabView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct CustomTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                NavigationStack {
                    HomeMainView()
                }
                .tint(.black)
            }

            Tab("Recipes", systemImage: "fork.knife") {
                RecipeMainView()
            }

            Tab("Data Analysis", systemImage: "list.clipboard") {
                AnalysisView()
            }

            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileMainView()
                }
                .tint(.black)
            }
        }
        .tint(.green)
    }
}


#Preview {
    CustomTabView()
}
