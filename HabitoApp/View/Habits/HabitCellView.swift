//
//  HabitCellView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitCellView: View {

    @Binding var info: (id: Int, habit: Habit, asset: HabitAsset)

    var body: some View {
        VStack {
            HStack {
                Image(info.asset.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .padding(.leading, 5)
                VStack {
                    infoLine
                    LineProgress(percentage: Double(info.habit.count) / Double(info.habit.total))
                        .frame(maxHeight: 10)
                        .padding(.trailing, 25)
                }
                .padding(.leading, 5)
            }
        }
        .padding()
        .background {
            cellBackground
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    var cellBackground: some View {
        Image(info.asset.backImage)
            .resizable()
            .scaledToFill()
            .opacity(0.5)
            .background {
                LinearGradient(gradient: Gradient(colors: [.customSecondary, .white]), startPoint: .leading, endPoint: .trailing)
            }
    }

    var infoLine: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(info.asset.title)
                    .bold()
                Text("\(info.habit.count)/\(info.habit.total) \(info.asset.unit)")
                    .fontWeight(.light)
            }
            Spacer()
            NavigationLink() {
                HabitTrackView(info: $info)
            } label: {
                Image(systemName: "chevron.right.circle")
                    .foregroundStyle(.black)
            }
        }
    }
}

struct LineProgress: View {
    var percentage: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.white)
            GeometryReader {geometry in
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: Gradient(colors: [.customPrimary, .customSecondary]), startPoint: .leading, endPoint: .trailing))
                    .frame(maxWidth: percentage * geometry.size.width)
            }
        }
    }
}


//#Preview {
//    HabitCellView(title: "Test Habit", subtitle: "Progress", percentage: 0.5, mainImage: UIImage(systemName: "square")!, backImage: UIImage(named: "back")!)
//}
