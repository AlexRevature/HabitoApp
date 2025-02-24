//
//  ProfileEditView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/7/25.
//

import SwiftUI
import PhotosUI

struct ProfileEditView: View {

    @State var password: String = ""
    @State var passwordVerify: String = ""
    @State private var photoSelection: PhotosPickerItem?

    @State var imageData: Data?
    @State var name: String = ""
    @State var phone: String = ""

    @State var invalidPassword = false

    @Environment(AccountViewModel.self) var viewModel

    var body: some View {
        ScrollView {
            userInfo
            entries
                .padding(.horizontal, 25)
            if (invalidPassword) {
                Text("Passwords must match")
                    .foregroundStyle(.red)
                    .padding(.top, 5)
            }
        }
        .toolbar {
            Button {
                saveInfo()
            } label: {
                Text("Save")
                    .foregroundStyle(.customPrimary)
            }
        }
        .task {
            imageData = viewModel.currentUser?.image
            name = viewModel.currentUser?.name ?? ""
            phone = viewModel.currentUser?.phone ?? ""
        }
    }

    func saveInfo() {

        if password != passwordVerify {
            invalidPassword = true
            return
        }

        @Bindable var vm = viewModel
        vm.currentUser?.name = name
        vm.currentUser?.phone = phone
        vm.currentUser?.image = imageData

        if viewModel.currentUser != nil {
            try? KeychainManager.updatePassword(id: "\(viewModel.currentUser!.id)", newPassword: password)
        }
    }

    var userInfo: some View {
        VStack {
            ZStack {
                userImage
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 140, height: 140)
                    .clipped()
                    .padding(.bottom, 8)
                VStack {
                    Spacer()
                    PhotosPicker(selection: $photoSelection, matching: .images) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .foregroundStyle(.customPrimary)
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 30)
                            .background(.white)
                            .clipShape(Circle())
                    }
                    .onChange(of: photoSelection) {
                        Task {
                            if let loaded = try? await photoSelection?.loadTransferable(type: Data.self) {
                                imageData = loaded
                            } else {
                                print("Failed")
                            }
                        }
                    }
                }
            }
            .padding(.top, 30)
            .padding(.bottom, 2)

            Text("\(viewModel.currentUser?.email ?? "")")
                .padding(.bottom, 15)
        }
    }

    var userImage: Image {
        if let imageData {
            Image(uiImage: UIImage(data: imageData)!)
        } else {
            Image(systemName: "person.circle")
        }
    }

    var entries: some View {
        return VStack(alignment: .leading) {
            Text("Name")
                .font(.headline)
            wrappedTextField(placeholder: "Name", record: $name)
                .padding(.bottom, 10)
            Text("Phone Number")
                .font(.headline)
            wrappedTextField(placeholder: "Phone Number", record: $phone)
                .padding(.bottom, 10)
            Text("Password")
                .font(.headline)
            wrappedTextField(placeholder: "Password", record: $password, isSecure: true, isError: invalidPassword)
                .padding(.bottom, 10)
            Text("Verify Password")
                .font(.headline)
            wrappedTextField(placeholder: "Password", record: $passwordVerify, isSecure: true, isError: invalidPassword)
                .padding(.bottom, 10)
        }
    }

    func wrappedTextField(placeholder: String, record: Binding<String>, isSecure: Bool = false, isError: Bool = false, identifier: String? = nil) -> some View {

        var textField: AnyView {
            if !isSecure {
                AnyView (
                    TextField(placeholder, text: record)
                        .autocapitalization(.none)
                        .if(identifier != nil) {
                            $0.accessibilityIdentifier(identifier!)
                        }
                )
            } else {
                AnyView (
                    SecureField(placeholder, text: record)
                        .textContentType(.oneTimeCode)
                        .if(identifier != nil) {
                            $0.accessibilityIdentifier(identifier!)
                        }
                )
            }
        }

        let returnView = textField
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isError ? Color.red : Color.customPrimary, lineWidth: 1)
            }

        return returnView
    }
}

#Preview {

    @Previewable @AppStorage("currentID") var currentID: Int?
    @Previewable @State var viewModel = AccountViewModel()

    currentID = nil

    try? KeychainManager.deleteCredentials()
    let user = try? viewModel.createUser(name: "John Test", email: "test@test.com", phone: "1236540987", password: "password")

    viewModel.currentUser = user

    return NavigationStack {
        ProfileEditView()
    }
    .environment(viewModel)
}
