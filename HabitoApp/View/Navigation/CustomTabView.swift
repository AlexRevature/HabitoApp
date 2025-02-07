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
                Text("Recipes")
            }

            Tab("Data Analysis", systemImage: "list.clipboard") {
                Text("Data")
            }

            Tab("Profile", systemImage: "person") {
                ProfileMainView()
            }
        }
        .tint(.green)
    }
}


#Preview {
    CustomTabView()
}
