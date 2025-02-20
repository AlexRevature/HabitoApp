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
    let viewModel = ChallengeViewModel()
    @Environment(AccountViewModel.self) var accountViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.oldestChallenge(userID: accountViewModel.currentUser?.id)?.title ?? "No challenges")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
          
            Text(viewModel.oldestChallenge(userID: accountViewModel.currentUser?.id)?.message ?? "")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.top, 5)
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

//#Preview {
//    ChallengeCardView(dayNumber: 10, totalDays: 30, challengeTitle: "Challenge Title", image: UIImage(named: "sample")!)
//}
