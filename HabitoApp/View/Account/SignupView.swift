//
//  SignupView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import AuthenticationServices

struct SignupView: View {

    @Environment(AccountViewModel.self) var viewModel

    @State var name: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var passwordVerify: String = ""
    @State var hasReadTerms = false

    @State var nameErr = false
    @State var emailErr = false
    @State var phoneErr = false
    @State var passwordErr = false
    @State var termsErr = false

    @State var errMessage = ""

    var body: some View {
        ScrollView {
            header
                .padding(.top, 20)
                .padding(.bottom, 15)

            entries
                .padding(.horizontal, 25)
                .padding(.bottom, 4)

            terms
                .padding(.bottom, 15)

            actionButton
                .padding(.horizontal, 20)

            if errMessage.count > 0 {
                Text(errMessage)
                    .foregroundStyle(.red)
                    .padding(3)
                    .padding(.top, 20)
            }

            externalRow
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
                    showGoogleSignin()
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
                    handleGoogleAuth(result: result)
                }
                .signInWithAppleButtonStyle(.black)
                .frame(maxWidth: 150)
                .cornerRadius(15)
            }
        }
    }

    func handleGoogleAuth(result: Result<ASAuthorization, any Error>) {
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

    func showGoogleSignin() {
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
            viewModel.currentUser = user
        }

    }

    var header: some View {
        VStack {
            Text("Sign Up")
                .fontWeight(.bold)
                .padding(.bottom, 2)
            Text("Let's create an account for you!")
                .foregroundStyle(.customPrimary)
        }
    }

    var entries: some View {
        VStack(alignment: .leading) {
            Text("Name")
                .font(.headline)
            wrappedTextField(placeholder: "Name", record: $name, isError: nameErr, identifier: "signUpNameField")
                .padding(.bottom, 10)
            Text("Email")
                .font(.headline)
            wrappedTextField(placeholder: "Email", record: $email, isError: emailErr, identifier: "signUpEmailField")
                .padding(.bottom, 10)
            Text("Phone Number")
                .font(.headline)
            wrappedTextField(placeholder: "Phone Number", record: $phone, isError: phoneErr, identifier: "signUpPhoneField")
                .padding(.bottom, 10)
            Text("Password")
                .font(.headline)
            wrappedTextField(placeholder: "Password", record: $password, isSecure: true, isError: passwordErr, identifier: "signUpPasswordField")
                .padding(.bottom, 10)
            Text("Verify Password")
                .font(.headline)
            wrappedTextField(placeholder: "Password", record: $passwordVerify, isSecure: true, isError: passwordErr, identifier: "signUpVerifyField")
                .padding(.bottom, 10)
        }
    }

    var terms: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    hasReadTerms.toggle()
                }
            } label: {
                Image(systemName: hasReadTerms ? "checkmark.square.fill" : "square")
            }
            .accessibilityIdentifier("signUpTermsButton")
            Text("I agree to the terms and privacy policy")
        }
        .foregroundStyle(termsErr ? .red : .black)
    }

    var actionButton: some View {
        Button {
            try? KeychainManager.deleteCredentials()
            signupAction()
        } label: {
            Text("Sign Up")
                .tint(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(.customPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .accessibilityIdentifier("signUpMainButton")
    }

    func resetErrorVars() {
        nameErr = false
        emailErr = false
        phoneErr = false
        passwordErr = false
        termsErr = false
    }

    func signupAction() {
        resetErrorVars()

        do {
            try viewModel.verifyInformation(name: name, email: email, phone: phone, password: password, passwordVerify: passwordVerify)

        } catch AccountError.name(let msg) {
            nameErr = true
            errMessage = msg
            return
        } catch AccountError.email(let msg) {
            emailErr = true
            errMessage = msg
            return
        } catch AccountError.phone(let msg) {
            phoneErr = true
            errMessage = msg
            return
        } catch AccountError.password(let msg) {
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

        guard hasReadTerms else {
            termsErr = true
            errMessage = "You must agree to the terms"
            return
        }

        let user: User
        do {
            user = try viewModel.createUser(name: name, email: email, phone: phone, password: password)
        } catch {
            print("System error")
            return
        }

        viewModel.currentUser = user
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

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    SignupView()
        .environment(AccountViewModel())
}
