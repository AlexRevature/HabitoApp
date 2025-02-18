//
//  SigninView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices

struct SigninView: View {

    @AppStorage("currentID") var currentID: Int?
    @Environment(AccountViewModel.self) var viewModel

    @State var email = ""
    @State var password = ""
    @State var shouldRemember = false

    @State var emailErr = false
    @State var passwordErr = false
    @State var errMessage: String = ""

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
            externalRow
                .padding(.top, 20)

            Text(errMessage)
                .foregroundStyle(.red)
                .padding(.top, 20)
        }
    }

    var externalRow: some View {
        VStack {
            HStack {
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.customSecondary)
                Text("Or login with")
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.customSecondary)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 8)

            HStack {
                Button {
                    googleAction()
                } label: {
                    HStack {
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(10)
                        Text("Google")
                            .foregroundStyle(.blue)
                            .padding(.trailing, 20)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.customSecondary, lineWidth: 1.5)
                    }
                    .padding(.horizontal, 10)
                }

                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                        case .success(let authorization):
                            if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                let name = userCredential.fullName
                                let email = userCredential.email

                                guard let name, let email else { return }
                                let fullname = (name.givenName ?? "") + " " + (name.familyName ?? "")

                                var user = UserManager.shared.fetchDataByEmail(email: email)
                                if user == nil {
                                    do {
                                        user = try viewModel.createUser(name: fullname, email: email, phone: "", password: "", keychain: false)
                                    } catch {
                                        print("Google signin error")
                                    }
                                }
                                self.viewModel.currentUser = user
                            }
                        default:
                            return
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(maxWidth: 150)
                .cornerRadius(15)
            }
        }
    }
    func googleAction() {
        let clientID = "706899943928-o8bj68noc80uh5fuopcsd70eer0677dl.apps.googleusercontent.com"

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard error == nil, let googleUser = result?.user else { return }
            guard let profile = googleUser.profile else { return }

            var user = UserManager.shared.fetchDataByEmail(email: email)
            if user == nil {
                do {
                    user = try viewModel.createUser(name: profile.name, email: profile.email, phone: "", password: "", keychain: false)
                } catch {
                    print("Google signin error")
                }
            }

            self.viewModel.currentUser = user
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
            errMessage = msg
            return
        } catch AccountError.password(let msg) {
            passwordErr = true
            errMessage = msg
            return
        } catch AccountError.verification(let msg) {
            emailErr = true
            passwordErr = true
            errMessage = msg
            return
        } catch AccountError.system(let msg) {
            errMessage = msg
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
