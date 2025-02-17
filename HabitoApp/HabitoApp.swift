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
    @State var habitViewModel = HabitViewModel()

    var body: some Scene {

        habitViewModel.accountViewModel = accountViewModel

        return WindowGroup {
            RootView()
                .environment(accountViewModel)
                .environment(habitViewModel)
        }
    }
}
