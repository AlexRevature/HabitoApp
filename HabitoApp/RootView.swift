//
//  RootView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/13/25.
//

import SwiftUI

struct RootView: View {

    //HabitHelper

    @AppStorage("currentID") var currentID: Int?
    @Environment(AccountViewModel.self) var viewModel
    @State var isChecking = true

    var body: some View {
        Group {
            if isChecking {
                Text("")
            } else if viewModel.currentUser == nil {
                NavigationStack {
                    GuideView()
                }
            } else {
                CustomTabView()
            }
        }
        .animation(.linear(duration: 0.5), value: viewModel.currentUser)
        .onAppear {
            persistenceCheck()
        }
    }

    func persistenceCheck() {

        defer {
            isChecking = false
        }
        guard let currentID else {
            return
        }

        let user: User
        do {
            user = try viewModel.retrieveUserByID(id: currentID)
        } catch {
            print("err")
            return
        }

        viewModel.currentUser = user
        return
    }
}

#Preview {

    @Previewable @AppStorage("currentID") var currentID: Int?
    @Previewable @State var accountViewModel = AccountViewModel()
    @Previewable @State var habitViewModel = HabitViewModel()

    currentID = nil

    try? KeychainManager.deleteCredentials()
    let user = try? accountViewModel.createUser(name: "Test User", email: "test@test.com", phone: "(123) 654-0987", password: "password")

    habitViewModel.accountViewModel = accountViewModel

//    accountViewModel.currentUser = user

    return RootView()
        .environment(accountViewModel)
        .environment(habitViewModel)
}
