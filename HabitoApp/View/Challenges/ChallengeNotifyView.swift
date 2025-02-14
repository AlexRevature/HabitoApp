//
//  ChallengeNotifyView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct ChallengeNotifyView: View {
    var body: some View {
        VStack {
            Image(systemName: "trophy")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 170)
                .padding(.bottom, 40)
            Text("Challenge Completed 🎉!")
                .font(.title)
                .foregroundStyle(.blue)
                .padding(.bottom, 30)
            Text("You successfully completed your challenge for the day. Keep up the great work!")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .padding(.bottom, 40)
            Button {
                print("Challenge Shared")
            } label: {
                Text("Share")
                    .tint(.white)
                    .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30))
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Spacer()
        }
        .padding(.top, 50)
    }
}

#Preview {
    ChallengeNotifyView()
}
