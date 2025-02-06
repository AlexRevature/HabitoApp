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

    var body: some View {
        VStack {
            HStack {
                PercentageCircle(percentage: 0.5)
                    .frame(maxWidth: 70, maxHeight: 70)
                    .padding(.leading, 6)

                VStack {
                    Text(title)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(subtitle)
                        .font(.callout)
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
        .overlay(
            RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1)
        )
        .padding(.top, 1)
    }
}

private struct PercentageCircle: View {
    var percentage: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)

            Circle()
                .trim(from: 0, to: percentage)
                .stroke(Color.green, lineWidth: 8)
                .rotationEffect(.degrees(-90))

            Text("\(Int(percentage * 100))%")
                .font(.title2)
                .bold()
        }
    }
}

#Preview {
    @Previewable @State var count = 0
    var title = "Title"
    var subtitle = "Subtitle"

    HabitCardView(number: $count, title: title, subtitle: subtitle)
}
