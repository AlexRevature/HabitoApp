//
//  HabitCellView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitCellView: View {

    var title: String
    var subtitle: String
    var percentage: Double
    var mainImage: UIImage
    var backImage: UIImage

    var body: some View {
        VStack {
            HStack {
                Image(uiImage: mainImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 80, maxHeight: 80)
                VStack {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(title)
                            Text(subtitle)
                        }
                        Spacer()
                        NavigationLink() {
                            HabitTrackView(mainMessage: "Hey There!", secondaryMessage: "You're using Whatsapp", image: UIImage(systemName: "circle")!)
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    LineProgress(percentage: 0.5)
                        .frame(maxHeight: 10)
                }
                .padding(.leading, 5)
            }
        }
        .padding()
        .background {
            Image(uiImage: backImage)
                .resizable()
                .scaledToFill()
                .opacity(0.8)
                .background(.green)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct LineProgress: View {
    var percentage: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.gray)
            GeometryReader {geometry in
                RoundedRectangle(cornerRadius: 5)
                    .fill(.green)
                    .frame(maxWidth: percentage * geometry.size.width)
            }
        }
    }
}


#Preview {
    HabitCellView(title: "Test Habit", subtitle: "Progress", percentage: 0.5, mainImage: UIImage(systemName: "square")!, backImage: UIImage(named: "back")!)
}
