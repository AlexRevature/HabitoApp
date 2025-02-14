//
//  GuideView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct GuideView: View {
    var body: some View {
        VStack {
            // TODO: Change to actual image
            Image(systemName: "book.fill")
                .padding(.top, 40)

            introText
                .padding(.horizontal, 50)
                .padding(.top, 30)
            Spacer()
            // TODO: Change to actual image
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Spacer()
            actionButton
                .padding(.horizontal, 30)
                .padding(.top, 20)
            signinBar
                .padding(.top, 20)
                .padding(.bottom, 25)
        }
    }

    var introText: some View {
        VStack {
            Text("Welcome to Habito")
                .font(.title)
                .padding(.bottom, 15)
            Text("Build healthy habits, track your progress, and stay motivated every day")
                .multilineTextAlignment(.center)
        }
    }

    var actionButton: some View {
        NavigationLink(destination: SignupView()) {
            Text("Get Started")
                .tint(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(.customPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    var signinBar: some View {
        HStack {
            Text("Already have an account?")
            NavigationLink(destination: SigninView()) {
                Text("Sign in")
                    .foregroundStyle(.customPrimary)
                    .fontWeight(.semibold)
            }
            .zIndex(1)
        }
    }
}

#Preview {
    NavigationStack {
        GuideView()
    }
    .environment(AccountViewModel())
}
