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
    var actionList = [ProfileActionInfo<AnyView>]()

    init() {
        userInfo = fetchTestUserInfo() // Actual data may be fetched async
        actionList = fetchActionList() // Could be async if destinations load slowly
    }

    private func fetchTestUserInfo() -> ProfileUserInfo {
        return ProfileUserInfo(name: "Joanna Swift", email: "test@test.com", phone: "(987) 456-1234", image: UIImage(named: "profile")!, password: "password")
    }

    func fetchActionList() -> [ProfileActionInfo<AnyView>] {
        let selectOptions = [
            ProfileActionInfo(imageName: "person", text: "Personal data", tintColor: .black) {
                AnyView(ProfileEditView(info: self.userInfo!))
            },
            ProfileActionInfo(imageName: "questionmark.circle", text: "Help", tintColor: .black) {
                AnyView(Text(""))
            },
            ProfileActionInfo(imageName: "trash", text: "Delete account", tintColor: .black) {
                AnyView(Text(""))
            },
            ProfileActionInfo(imageName: "power", text: "Log out", tintColor: .red) {
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
    var phone: String
    var image: UIImage
    var password: String

}

struct ProfileActionInfo<Destination>: Identifiable where Destination: View {
    var id = UUID()
    let imageName: String
    let text: String
    let tintColor: Color
    let destination: () -> Destination

    init(imageName: String, text: String, tintColor: Color, @ViewBuilder destination: @escaping () -> Destination) {
        self.imageName = imageName
        self.text = text
        self.tintColor = tintColor
        self.destination = destination
    }
}
