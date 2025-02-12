//
//  SignupView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct SignupView: View {

    @State var username: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var password: String = ""
    @State var passwordVerify: String = ""
    @State var hasReadTerms = false

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

            Spacer()
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
            Text("Username")
                .font(.headline)
            wrappedTextField(placeholder: "Username", record: $username)
                .padding(.bottom, 10)
            Text("Email")
                .font(.headline)
            wrappedTextField(placeholder: "Email", record: $email)
                .padding(.bottom, 10)
            Text("Phone Number")
                .font(.headline)
            wrappedTextField(placeholder: "Phone Number", record: $phone)
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

    var terms: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.1)) {
                    hasReadTerms.toggle()
                }
            } label: {
                Image(systemName: hasReadTerms ? "checkmark.square.fill" : "square")
                    .foregroundStyle(.black)
            }
            Text("I agree to the terms and privacy policy")
        }
    }

    var actionButton: some View {
        Button {

        } label: {
            Text("Sign Up")
                .tint(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(.customPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
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

#Preview {
    SignupView()
}
