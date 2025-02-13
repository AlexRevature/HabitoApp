//
//  RootView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/13/25.
//

import SwiftUI

struct RootView: View {

    @Environment(AccountViewModel.self) var viewModel

    var body: some View {
        NavigationStack {
            if viewModel.currentUser == nil {
                GuideView()
            } else {
                CustomTabView()
            }
        }
        .animation(.linear(duration: 1), value: viewModel.currentUser)
    }
}

#Preview {

    let viewModel = AccountViewModel()

    try? KeychainManager.deleteCredentials()
    _ = try? viewModel.createUser(username: "test", email: "test@test.com", phone: "1236540987", password: "password1#", passwordVerify: "password1#")

    return RootView().environment(viewModel)
}
