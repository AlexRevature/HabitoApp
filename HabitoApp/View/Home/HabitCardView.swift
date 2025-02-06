//
//  HabitCardView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitCardView: View {
    @Binding var number: Int

    var title: String
    var subtitle: String
    var image: UIImage

    var body: some View {
        VStack {
            HStack {
                PercentageCircle(percentage: 0.5)
                    .frame(maxWidth: 70, maxHeight: 70)
                    .padding(.leading, 6)

                VStack {
                    Text(title)
                        .font(.title2)
                        .foregroundStyle(.white)
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(subtitle)
                        .font(.callout)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        IncrementButton(count: $number)

                        Spacer()
                    }
                }
                .padding(.leading, 20)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1)
        )
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

private struct IncrementButton: View {
    @Binding var count: Int

    var body: some View {
        HStack {
            Button("-") {
                count -= 1
            }
            Text("\(count)")
            Button("+") {
                count += 1
            }
        }
        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct PercentageCircle: View {
    var percentage: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.9), lineWidth: 8)

            Circle()
                .trim(from: 0, to: percentage)
                .stroke(Color.green, lineWidth: 8)
                .rotationEffect(.degrees(-90))

            Text("\(Int(percentage * 100))%")
                .font(.title2)
                .foregroundStyle(.white)
                .bold()
        }
    }
}

#Preview {
    @Previewable @State var count = 0
    let title = "Title"
    let subtitle = "Subtitle"

    HabitCardView(number: $count, title: title, subtitle: subtitle, image: UIImage(named: "sample")!)
}
