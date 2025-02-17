//
//  RootView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/13/25.
//

import SwiftUI

struct RootView: View {

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
            withAnimation(.linear(duration: 1)) {
                persistenceCheck()
            }
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
    let habitViewModel = HabitViewModel(accountViewModel: accountViewModel)

    currentID = nil

    try? KeychainManager.deleteCredentials()
    let user = try? accountViewModel.createUser(name: "test", email: "test@test.com", phone: "1236540987", password: "password1#", passwordVerify: "password1#")

//    accountViewModel.currentUser = user

    return RootView()
        .environment(accountViewModel)
        .environment(habitViewModel)
}
