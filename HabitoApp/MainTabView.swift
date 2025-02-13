//
//  MainTabView.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/13/25.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                ContentView()
                    .navigationBarTitle("Home", displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationView {
                ProfileMainView()
                    .navigationBarTitle("Profile", displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            
            NavigationView {
                HabitMainView()
                    .navigationBarTitle("Habits", displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Habits")
            }
            
            NavigationView {
                RecipeMainView()
                    .navigationBarTitle("Recipes", displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Recipes")
            }
        }
    }
}
