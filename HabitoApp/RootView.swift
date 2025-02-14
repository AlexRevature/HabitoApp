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
                Text("Checking")
            } else if viewModel.currentUser == nil {
                NavigationStack {
                    GuideView()
                }
            } else {
                CustomTabView()
            }
        }
        .animation(.linear(duration: 1), value: viewModel.currentUser)
        .onAppear {
            withAnimation(.easeInOut(duration: 5)) {
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
    let viewModel = AccountViewModel()

    currentID = nil

    try? KeychainManager.deleteCredentials()
    _ = try? viewModel.createUser(username: "test", email: "test@test.com", phone: "1236540987", password: "password1#", passwordVerify: "password1#")

    return RootView().environment(viewModel)
}
