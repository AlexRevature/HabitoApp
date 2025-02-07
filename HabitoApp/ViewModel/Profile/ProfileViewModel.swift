//
//  ProfileViewModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

@Observable
class ProfileViewModel {

    var userInfo: ProfileUserInfo?
    var actionList =  [ProfileActionInfo<AnyView>]()

    init() {
        userInfo = fetchTestUserInfo() // Actual data may fetched async
        actionList = fetchActionList() // Could be async if destinations load slowly
    }

    private func fetchTestUserInfo() -> ProfileUserInfo {
        return ProfileUserInfo(name: "John Swift", email: "test@test.com", image: UIImage(systemName: "person.circle")!)
    }

    func fetchActionList() -> [ProfileActionInfo<AnyView>] {
        let selectOptions = [
            ProfileActionInfo(actionImage: UIImage(systemName: "person")!, text: "Personal data", tintColor: .black) {
                AnyView(Text(""))
            },
            ProfileActionInfo(actionImage: UIImage(systemName: "person")!, text: "Help", tintColor: .black) {
                AnyView(Text(""))
            },
            ProfileActionInfo(actionImage: UIImage(systemName: "person")!, text: "Delete account", tintColor: .black) {
                AnyView(Text(""))
            },
            ProfileActionInfo(actionImage: UIImage(systemName: "person")!, text: "Log out", tintColor: .red) {
                AnyView(Text(""))
            }
        ]
        return selectOptions
    }
}

struct ProfileUserInfo: Identifiable {
    var id = UUID()
    var name: String
    var email: String
    var image: UIImage

}

struct ProfileActionInfo<Destination>: Identifiable where Destination: View {
    var id = UUID()
    let actionImage: UIImage
    let text: String
    let tintColor: Color
    let destination: () -> Destination

    init(actionImage: UIImage, text: String, tintColor: Color, @ViewBuilder destination: @escaping () -> Destination) {
        self.actionImage = actionImage
        self.text = text
        self.tintColor = tintColor
        self.destination = destination
    }
}
