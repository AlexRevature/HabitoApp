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
        .onChange(of: viewModel.currentUser) {
//            print(viewModel.currentUser?.name)
        }
        .task {
            print(viewModel.currentUser?.name)
        }
    }

    var actionList: some View {
        List {
            ActionRow(imageName: "person", text: "Personal data", tint: .black, trigger: $editTrigger)
                .navigationDestination(isPresented: $editTrigger) { ProfileEditView()
                }
            ActionRow(imageName: "questionmark.circle", text: "Help", tint: .black, trigger: $helpTrigger)
            ActionRow(imageName: "trash", text: "Delete account", tint: .black, trigger: $deleteTrigger)
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
    var body: some View {
        HStack {
            ForEach(0..<3) { idx in
                LayerCell()
                    .padding(.horizontal, 10)
            }
        }
    }
}

private struct LayerCell: View {
    var body: some View {
        VStack {
            Image(systemName: "circle")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 60)
            Text("Test 1")
            Text("Test 2")
        }
    }
}


#Preview {

    @Previewable @AppStorage("currentID") var currentID: Int?
    @Previewable @State var viewModel = AccountViewModel()

    currentID = nil

    try? KeychainManager.deleteCredentials()
    let user = try? viewModel.createUser(name: "test", email: "test@test.com", phone: "1236540987", password: "password1#", passwordVerify: "password1#")

    viewModel.currentUser = user

    return NavigationStack {
        ProfileMainView()
    }
    .environment(viewModel)
}
