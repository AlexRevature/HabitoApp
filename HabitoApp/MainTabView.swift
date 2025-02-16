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
                HomeMainView()
                    .navigationBarTitle("Home", displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            NavigationView {
                GuideMainView()
                    .navigationBarTitle("Guides", displayMode: .inline)
            }
            .tabItem(){
                Image(systemName: "book.fill")
                Text("Guides")
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
            NavigationView {
                ChallengeMainView()
                    .navigationBarTitle(Text("Challenges"), displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "trophy.fill")
                Text("Challenges")
            }
        }
    }
}

#Preview {
    MainTabView()
}
