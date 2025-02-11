//
//  HabitCellView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitCellView: View {

    @Binding var info: HabitInfoFull

    var body: some View {
        VStack {
            HStack {
                Image(uiImage: info.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 80, maxHeight: 80)
                VStack {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(info.title)
                            Text(info.subtitle)
                        }
                        Spacer()
                        NavigationLink() {
                            HabitTrackView(info: $info)
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    LineProgress(percentage: Double(info.count) / Double(info.total))
                        .frame(maxHeight: 10)
                }
                .padding(.leading, 5)
            }
        }
        .padding()
        .background {
            Image(uiImage: info.backImage)
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


//#Preview {
//    HabitCellView(title: "Test Habit", subtitle: "Progress", percentage: 0.5, mainImage: UIImage(systemName: "square")!, backImage: UIImage(named: "back")!)
//}
