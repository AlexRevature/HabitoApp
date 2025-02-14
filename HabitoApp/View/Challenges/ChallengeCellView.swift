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
                Image(uiImage: info.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .padding(.leading, 5)
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(info.title)
                                .bold()
                            Text("\(info.count)/\(info.total) \(info.unit)")
                                .fontWeight(.light)
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
        .background {
            Image(uiImage: info.backImage)
                .resizable()
                .scaledToFill()
                .opacity(0.5)
                .background {
                    LinearGradient(gradient: Gradient(colors: [.customSecondary, .white]), startPoint: .leading, endPoint: .trailing)
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}


