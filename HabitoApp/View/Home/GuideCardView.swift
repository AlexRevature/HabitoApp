//
//  GuideCardView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct GuideCardView: View {

    var title: String
    var subtitle: String
    var image: UIImage

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(title)
                    .font(.title)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 40)
            Spacer()
        }
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
    GuideCardView(title: "Title", subtitle: "Subtitle", image: UIImage(named: "sample")!)
}
