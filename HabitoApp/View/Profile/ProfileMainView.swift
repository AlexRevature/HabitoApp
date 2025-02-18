//
//  ProfileMainView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct ProfileMainView: View {

    @Environment(AccountViewModel.self) var viewModel

    @State var refresh = false

    @State var editTrigger = false
    @State var helpTrigger = false
    @State var deleteTrigger = false
    @State var logoutTrigger = false

    var body: some View {

        VStack {
            getImage()
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 140, height: 140)
                .padding(.top, 30)
                .padding(.bottom, 2)
            Text(viewModel.currentUser?.name ?? "Empty")
                .bold()
            Text(viewModel.currentUser?.email ?? "N/A")
                .padding(.bottom, 15)
            LayerInfo()
                .padding(.bottom, 5)

            actionList
            Spacer()
        }
    }

    var actionList: some View {
        List {
            ActionRow(imageName: "person", text: "Edit profile", tint: .black, trigger: $editTrigger)
                .navigationDestination(isPresented: $editTrigger) { ProfileEditView()
                }
//            ActionRow(imageName: "questionmark.circle", text: "Help", tint: .black, trigger: $helpTrigger)

            ActionRow(imageName: "trash", text: "Delete account", tint: .black, trigger: $deleteTrigger)
                .onChange(of: deleteTrigger) {
                    viewModel.deleteUser()
                }
            ActionRow(imageName: "power", text: "Log out", tint: .red, trigger: $logoutTrigger)
                .onChange(of: logoutTrigger) {
                    viewModel.logoutUser()
                }
        }
    }

    func getImage() -> Image {
        if viewModel.currentUser?.image == nil {
            Image(systemName: "person.circle")
        } else {
            Image(uiImage: UIImage(data: viewModel.currentUser!.image!)!)
        }
    }
}

private struct ActionRow: View {

    var imageName: String
    var text: String
    var tint: Color
    @Binding var trigger: Bool

    var body: some View {

        Button {
            trigger.toggle()
        } label: {
            HStack {
                Image(systemName: imageName)
                    .padding(.trailing, 8)
                Text(text)
                Spacer()
            }
            .foregroundStyle(tint)
            .padding(.vertical, 8)
        }
    }
}

private struct LayerInfo: View {
    @Environment(HabitViewModel.self) var habitViewModel

    var body: some View {
        let habitPackets = habitViewModel.getHabits(date: Date())
        HStack {
            LayerCell(textOne: "\(habitPackets?[0].habit.count ?? 0)", textTwo: "\(habitPackets?[0].asset.unit ?? "")", imageName: "drop.fill")
                .padding(.horizontal, 8)
            LayerCell(textOne: "\(habitPackets?[2].habit.count ?? 0)", textTwo: "\(habitPackets?[2].asset.unit ?? "")", imageName: "powersleep")
                .padding(.horizontal, 8)
            LayerCell(textOne: "\(habitPackets?[3].habit.count ?? 0)", textTwo: "\(habitPackets?[3].asset.unit ?? "")", imageName: "dumbbell.fill")
                .padding(.horizontal, 8)
        }
    }
}

private struct LayerCell: View {
    var textOne: String
    var textTwo: String
    var imageName: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .foregroundStyle(.customPrimary)
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(textOne)
                .bold()
            Text(textTwo)
        }
        .frame(width: 70)
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.gray.opacity(0.15))
        }
    }
}


#Preview {

    @Previewable @AppStorage("currentID") var currentID: Int?
    @Previewable @State var accountViewModel = AccountViewModel()
    @Previewable @State var habitViewModel = HabitViewModel()

    currentID = nil

    try? KeychainManager.deleteCredentials()
    let user = try? accountViewModel.createUser(name: "John Tester", email: "test@test.com", phone: "1236540987", password: "password")

    accountViewModel.currentUser = user
    habitViewModel.accountViewModel = accountViewModel

    return ProfileMainView()
        .environment(accountViewModel)
        .environment(habitViewModel)
}
