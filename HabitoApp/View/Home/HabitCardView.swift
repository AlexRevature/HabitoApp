//
//  HabitCardView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitCardView: View {

    @Binding var habitInfoList: [HomeHabitInfo]
    @State var currentCard: HomeHabitInfo
    @State var currentIndex: Int

    init(habitInfoList: Binding<[HomeHabitInfo]>) {
        _habitInfoList = habitInfoList
        currentIndex = 0
        currentCard = habitInfoList[0].wrappedValue
    }

    var body: some View {
        frontView
        .padding()
        .background {
            Image(uiImage: currentCard.image)
                .resizable()
                .scaledToFill()
                .opacity(0.9)
                .background(.green)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    var frontView: some View {
        VStack {
            HStack {
                moveButton(imageName: "chevron.left", step: -1)
                PercentageCircle(percentage: 0.5)
                    .frame(maxWidth: 70, maxHeight: 70)
                    .padding(.leading, 6)

                VStack {
                    titleStack(title: currentCard.title, subtitle: currentCard.subtitle)

                    HStack {
                        IncrementButton(count: $habitInfoList[currentIndex].count)
                        Spacer()
                    }
                }
                .padding(.leading, 20)
                moveButton(imageName: "chevron.right", step: 1)
            }
        }
    }

    private func titleStack(title: String, subtitle: String) -> some View {
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
        }
    }

    private func moveButton(imageName: String, step: Int) -> some View {
        Button {
            var newIndex = (self.currentIndex + step) % habitInfoList.count
            if newIndex < 0 {
                newIndex = habitInfoList.count + newIndex
            }
            self.currentCard = self.habitInfoList[newIndex]
            self.currentIndex = newIndex
        } label: {
            Image(systemName: imageName)
        }
        .tint(.black)
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
    @Previewable @State var tmp = HomeViewModel().habitGroup!

    HabitCardView(habitInfoList: $tmp.habitInfoList)
}
