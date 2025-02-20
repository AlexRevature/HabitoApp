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
            
        }
        .padding(.top, 50)
    }
}

#Preview {
    ChallengeNotifyView()
}
