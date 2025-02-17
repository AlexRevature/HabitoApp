//
//  SigninView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct SigninView: View {

    @AppStorage("currentID") var currentID: Int?
    @Environment(AccountViewModel.self) var viewModel

    @State var email = ""
    @State var password = ""
    @State var shouldRemember = false

    @State var emailErr = false
    @State var passwordErr = false

    var body: some View {
        ScrollView {
            header
                .padding(.bottom, 15)
            entries
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
            stateActions
                .padding(.horizontal, 30)
                .padding(.bottom)
            actionButton
                .padding(.horizontal, 30)
        }
    }

    var header: some View {
        VStack {
            Image(.longIcon)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 90)
                .padding(.top, 50)
                .padding(.bottom, 20)
            Text("Welcome back!")
                .fontWeight(.bold)
                .padding(.bottom, 2)
            Text("Login in to continue your journey!")
                .foregroundStyle(.customPrimary)
        }
    }

    var entries: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .font(.headline)
            wrappedTextField(placeholder: "Email", record: $email)
                .padding(.bottom, 10)
            Text("Password")
                .font(.headline)
            wrappedTextField(placeholder: "Password", record: $password, isSecure: true)
                .padding(.bottom, 10)
        }
    }

    var stateActions: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    shouldRemember.toggle()
                }
            } label: {
                Image(systemName: shouldRemember ? "checkmark.square.fill" : "square")
                    .foregroundStyle(.black)
            }
            Text("Remember me?")
                .fontWeight(.medium)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    shouldRemember.toggle()
                }
            } label: {
                Text("Forgot Password?")
                    .fontWeight(.medium)
                    .foregroundStyle(.customPrimary)
            }
        }
    }

    var actionButton: some View {
        Button {
            signinAction()
        } label: {
            Text("Sign In")
                .tint(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(.customPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    func signinAction() {

        let user: User
        do {
            user = try viewModel.verifyUserByEmail(email: email, password: password)
        } catch AccountError.email(let msg) {
            emailErr = true
            print(msg)
            return
        } catch AccountError.password(let msg) {
            passwordErr = true
            print(msg)
            return
        } catch AccountError.verification(let msg) {
            emailErr = true
            passwordErr = true
            print(msg)
            return
        } catch AccountError.system(let msg) {
            print(msg)
            return
        } catch {
            print("err")
            return
        }

        currentID = shouldRemember ? user.id : nil


        viewModel.currentUser = user
    }

    func wrappedTextField(placeholder: String, record: Binding<String>, isSecure: Bool = false) -> some View {

        var textField: AnyView {
            if !isSecure {
                AnyView(TextField(placeholder, text: record).autocapitalization(.none))
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

#Preview {
    SigninView()
        .environment(AccountViewModel())
}
