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
    @Previewable @AppStorage("currentID") var currentID: Int?
    @Previewable @State var accountViewModel = AccountViewModel()
    let habitViewModel = HabitViewModel(accountViewModel: accountViewModel)

    currentID = nil

    try? KeychainManager.deleteCredentials()
    let user = try? accountViewModel.createUser(name: "John Tester", email: "test@test.com", phone: "1236540987", password: "password1#", passwordVerify: "password1#")

    accountViewModel.currentUser = user

    return CustomTabView()
        .environment(accountViewModel)
        .environment(habitViewModel)
}
