//
//  ChallengeCellView.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/13/25.
//

import SwiftUI

struct ChallengeCellView: View {

    @Binding var info: ChallengeInfoFull

    var body: some View {
        VStack {
            HStack {
                Image("running")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .padding(.leading, 5)
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(info.title)
                                .bold()
                        }
                        Spacer()
                        NavigationLink {
                          
                            ChallengeTrackView(info: $info)
                        } label: {
                            Image(systemName: "chevron.right.circle")
                                .foregroundStyle(.black)
                        }
                    }
                    
                }
                .padding(.leading, 5)
            }
        }
        .padding()
        .background (.green)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

