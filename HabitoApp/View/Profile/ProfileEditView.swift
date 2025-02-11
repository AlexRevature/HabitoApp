//
//  ProfileEditView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/7/25.
//

import SwiftUI
import PhotosUI

struct ProfileEditView: View {

    @Bindable var viewModel: ProfileViewModel
    @State var password: String = ""
    @State var passwordVerify: String = ""
    @State private var photoSelection: PhotosPickerItem?

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
                Image(uiImage: viewModel.userInfo!.image)
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
                                viewModel.userInfo!.image = UIImage(data: loaded)!
                            } else {
                                print("Failed")
                            }
                        }
                    }
                }
            }
//            .frame(width: 200, height: 200)
//            .background(.yellow)
            .padding(.top, 30)
            .padding(.bottom, 2)

            Text("Empty")
                .bold()
            Text("N/A")
                .padding(.bottom, 15)
        }
    }

    var entries: some View {
        VStack(alignment: .leading) {
            Text("Username")
                .font(.headline)
            wrappedTextField(placeholder: "Username", record: Binding($viewModel.userInfo)!.name)
                .padding(.bottom, 10)
            Text("Email")
                .font(.headline)
            wrappedTextField(placeholder: "Email", record: Binding($viewModel.userInfo)!.email)
                .padding(.bottom, 10)
            Text("Phone Number")
                .font(.headline)
            wrappedTextField(placeholder: "Phone Number", record: Binding($viewModel.userInfo)!.phone)
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
