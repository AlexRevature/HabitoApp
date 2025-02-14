//
//  ChallengesListView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct ChallengeListView: View {
    @Binding var challenges: [ChallengeInfoFull]

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach($challenges) { $challenge in
                    NavigationLink(destination: ChallengeTrackView(info: $challenge)) {
                        ChallengeCellView(info: $challenge)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 10)
                    }
                }
            }
        }
    }
}


#Preview {
    // For preview purposes, we use a constant binding from the test challenges.
    let viewModel = ChallengeViewModel()
    ChallengeListView(challenges: .constant(viewModel.getChallenges(for: Date())))
}
