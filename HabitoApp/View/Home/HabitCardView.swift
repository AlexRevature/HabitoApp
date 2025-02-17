//
//  HabitCardView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitCardView: View {

    @State var currentCard: HabitPacket?
    @State var currentIndex: Int

    @Environment(HabitViewModel.self) var habitViewModel

    init() {
        currentIndex = 0
    }

    var body: some View {
        VStack {
            frontView
                .padding(.horizontal)
                .padding(.vertical, 30)
                .background {
                    Image(currentCard?.asset.backImage ?? "back")
                        .resizable()
                        .scaledToFill()
                        .opacity(0.75)
                        .background(.green)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .task {
//            currentIndex = 0
            currentCard = habitViewModel.currentHabits[currentIndex]
        }
    }

    var frontView: some View {
        @Bindable var hb = habitViewModel
        let currentHabit = habitViewModel.currentHabits[currentIndex]
        return VStack {
            HStack {
                moveButton(imageName: "chevron.left", step: -1)
                PercentageCircle(percentage: Double(currentHabit.habit.count) / Double(currentHabit.habit.total))
                    .frame(maxWidth: 70, maxHeight: 70)
                    .padding(.leading, 6)

                VStack {
                    titleStack(title: currentCard?.asset.title ?? "", subtitle: currentCard?.asset.message ?? "")

                    HStack {
                        IncrementButton(count: $hb.currentHabits[currentIndex].habit.count, total: currentHabit.habit.total)
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
            var newIndex = (self.currentIndex + step) % habitViewModel.currentHabits.count
            if newIndex < 0 {
                newIndex = habitViewModel.currentHabits.count + newIndex
            }
            self.currentCard = habitViewModel.currentHabits[newIndex]
            self.currentIndex = newIndex
        } label: {
            Image(systemName: imageName)
        }
        .tint(.black)
    }
}

private struct IncrementButton: View {
    @Binding var count: Int
    var total: Int
    var step: Int = 1

    init(count: Binding<Int>, total: Int) {
        self._count = count
        self.total = total
        self.step = total / 10
        if self.step == 0 {
            self.step = 1
        }
    }

    var body: some View {
        HStack {
            Button("-") {
                if count >= step {
                    count -= step
                } else {
                    count = 0
                }
            }
            .disabled(count <= 0)
            Text("\(count)")
            Button("+") {
                if count < total - step {
                    count += step
                } else {
                    count = total
                }
            }
            .disabled(count >= total)
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

    HabitCardView()
        .environment(HabitViewModel(accountViewModel: AccountViewModel()))

}
