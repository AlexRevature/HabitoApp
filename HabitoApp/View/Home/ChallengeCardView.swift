//
//  ChallengeCardView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct ChallengeCardView: View {

    var dayNumber: Int
    var totalDays: Int
    var challengeTitle: String

    var body: some View {
        VStack {
            Text("Today's Challenge")
                .font(.headline)
                .frame(maxWidth: .infinity)
            Text("Day \(dayNumber) of \(totalDays)")
                .font(.callout)
            Text(challengeTitle)
                .font(.title2)
                .padding(.top, 5)

            Button(
                action: {
                    print("Something")
                },
                label: {
                    Text("Done")
                        .tint(.white)
                        .padding(EdgeInsets(top: 8, leading: 30, bottom: 8, trailing: 30))
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            )
            .padding (.top, 0.5)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1)
        )
    }
}

#Preview {
    ChallengeCardView(dayNumber: 10, totalDays: 30, challengeTitle: "Challenge Title")
}
