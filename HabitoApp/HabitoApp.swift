//
//  HabitoApp.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/4/25.
//

import SwiftUI

@main
struct HabitoApp: App {

    @State var accountViewModel = AccountViewModel()

    var body: some Scene {

        let habitViewModel = HabitViewModel(accountViewModel: accountViewModel)

        WindowGroup {
            RootView()
                .environment(accountViewModel)
                .environment(habitViewModel)
        }
    }
}
