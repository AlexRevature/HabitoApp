//
//  CustomTabView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct CustomTabView: View {

    @State var selection: Int = 0
    @Environment(AccountViewModel.self) var accountViewModel
    @Environment(HabitViewModel.self) var habitViewModel

    var body: some View {
        TabView(selection: $selection) {
            Tab("Home", systemImage: "house", value: 0) {
                NavigationStack {
                    HomeMainView()
                }
                .tint(.black)
            }

            Tab("Recipes", systemImage: "fork.knife", value: 1) {
                RecipeMainView()
            }

            Tab("Data Analysis", systemImage: "list.clipboard", value: 2) {
                AnalysisView()
            }

            Tab("Profile", systemImage: "person", value: 3) {
                NavigationStack {
                    ProfileMainView()
                }
                .tint(.black)
            }
        }
        .tint(.customPrimary)
//        .onChange(of: selection) {
//            habitViewModel.saveHabits()
//        }
    }
}


#Preview {
    @Previewable @AppStorage("currentID") var currentID: Int?
    @Previewable @State var accountViewModel = AccountViewModel()
    @Previewable @State var habitViewModel = HabitViewModel()

    currentID = nil

    try? KeychainManager.deleteCredentials()
    let user = try? accountViewModel.createUser(name: "John Tester", email: "test@test.com", phone: "1236540987", password: "password1#", passwordVerify: "password1#")

    accountViewModel.currentUser = user
    habitViewModel.accountViewModel = accountViewModel

    return CustomTabView()
        .environment(accountViewModel)
        .environment(habitViewModel)
}
