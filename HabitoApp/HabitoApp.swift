//
//  HabitoApp.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/4/25.
//

import SwiftUI

@main
struct HabitoApp: App {

    var body: some Scene {

        @State var accountViewModel = AccountViewModel()
        let habitViewModel = HabitViewModel(accountViewModel: accountViewModel)

        WindowGroup {
            RootView()
                .environment(accountViewModel)
                .environment(habitViewModel)
        }
    }
}
