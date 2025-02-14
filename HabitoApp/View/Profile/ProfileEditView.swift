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

    @Environment(AccountViewModel.self) var viewModel

    var body: some View {
        ScrollView {
            userInfo
            entries
                .padding(.horizontal, 25)
            Spacer()
        }
    }

    var userInfo: some View {
        VStack {
            ZStack {
                getImage()
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 160, height: 160)
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
                                viewModel.currentUser?.image = loaded
                            } else {
                                print("Failed")
                            }
                        }
                    }
                }
            }
            .padding(.top, 30)
            .padding(.bottom, 2)

            Text("Empty")
                .bold()
            Text("N/A")
                .padding(.bottom, 15)
        }
    }

    func getImage() -> Image {
        if viewModel.currentUser?.image == nil {
            Image(systemName: "person.circle")
        } else {
            Image(uiImage: UIImage(data: viewModel.currentUser!.image!)!)
        }
    }

    var entries: some View {
        @Bindable var vm = viewModel
        return VStack(alignment: .leading) {
            Text("Username")
                .font(.headline)
            wrappedTextField(placeholder: "Username", record: Binding($vm.currentUser)!.username)
                .padding(.bottom, 10)
            Text("Email")
                .font(.headline)
            wrappedTextField(placeholder: "Email", record: Binding($vm.currentUser)!.email)
                .padding(.bottom, 10)
            Text("Phone Number")
                .font(.headline)
            wrappedTextField(placeholder: "Phone Number", record: Binding($vm.currentUser)!.phone)
                .padding(.bottom, 10)
            Text("Password")
                .font(.headline)
            wrappedTextField(placeholder: "Password", record: $password, isSecure: true)
                .padding(.bottom, 10)
            Text("Verify Password")
                .font(.headline)
            wrappedTextField(placeholder: "Password", record: $passwordVerify, isSecure: true)
                .padding(.bottom, 10)
        }
    }

    func wrappedTextField(placeholder: String, record: Binding<String>, isSecure: Bool = false) -> some View {

        var textField: AnyView {
            if !isSecure {
                AnyView(TextField(placeholder, text: record))
            } else {
                AnyView(SecureField(placeholder, text: record))
            }
        }

        let returnView = textField
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.customPrimary, lineWidth: 1)
            }

        return returnView
    }
}

//#Preview {
//    let viewModel = ProfileViewModel()
//    ProfileEditView(info: viewModel.userInfo!)
//}
