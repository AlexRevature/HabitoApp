//
//  ContentView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                
                // NavigationLink to navigate to the recipe view.
                NavigationLink(destination: RecipeMainView()) {
                    Text("Go to Recipes")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("Main View")
        }
    }
}

#Preview {
    ContentView()
}

