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
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .padding(.leading, 5)
                VStack {
                    HStack{
                        VStack(alignment: .leading) {
                            Text(info.title)
                                .bold()
                            Text("\(info.count)/\(info.total) \(info.unit)")
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
                    LineProgress(percentage: Double(info.count) / Double(info.total))
                        .frame(maxHeight: 10)
                        .padding(.trailing, 25)
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
