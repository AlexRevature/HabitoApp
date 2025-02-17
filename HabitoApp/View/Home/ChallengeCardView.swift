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
    var image: UIImage

    var body: some View {
        VStack {
            Text("Today's Challenge")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
            Text("Day \(dayNumber) of \(totalDays)")
                .font(.callout)
                .foregroundStyle(.white)
            Text(challengeTitle)
                .font(.title2)
                .foregroundStyle(.white)
                .padding(.top, 5)

            Button {
                print("Something")
            } label: {
                Text("Done")
                    .tint(.white)
                    .padding(EdgeInsets(top: 8, leading: 30, bottom: 8, trailing: 30))
                    .background(.customPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding (.top, 0.5)
        }
        .padding()
        .background {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .opacity(0.9)
                .background(.green)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ChallengeCardView(dayNumber: 10, totalDays: 30, challengeTitle: "Challenge Title", image: UIImage(named: "sample")!)
}
