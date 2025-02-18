//
//  HabitTrackView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitTrackView: View {

    @Binding var info: HabitPacket
    @Binding var remainShown: Bool

    @State var value: Double
    @State var triggerCompletion = false

    init(info: Binding<HabitPacket>, remainShown: Binding<Bool>) {
        self._info = info
        self._remainShown = remainShown
        self.value = Double(info.wrappedValue.habit.count)
    }

    var body: some View {
        mainContent
    }

    var mainContent: some View {
        VStack {
            textStack
            moveStack
                .padding(.horizontal, 45)
                .padding(.bottom, 30)

            actionButton
                .navigationDestination(isPresented: $triggerCompletion) {
                    HabitNotifyView()
                }
            Spacer()
        }
        .padding(.top, 80)
        .onChange(of: value) {
            let count = Int(value)
            info.habit.count = count
        }
        .navigationTitle("\(info.asset.name) Details")
    }

    var actionButton: some View {
        Button {
            value = Double(info.habit.total)
            info.habit.count = info.habit.total
            triggerCompletion = true
        } label: {
            Text("Done")
                .tint(.white)
                .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30))
                .background(.customPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }

    var textStack: some View {
        VStack {
            Text(info.asset.title)
                .font(.title)
            Text(info.asset.message)
        }
    }

    var moveStack: some View {
        VStack {
            PercentageCircle(count: $value, total: Double(info.habit.total))
                .frame(width: 220, height: 220)
                .padding(.vertical, 90)
            Slider(
                value: $value,
                in: 0...Double(info.habit.total),
                step: 1
            )
            .tint(.customPrimary)
        }
    }

    var imageStack: some View {
        ZStack {
            Image(systemName: "circle")
                .resizable()
                .foregroundStyle(.blue)
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("\(info.habit.count) \(info.asset.unit)")
                .font(.title)
        }
    }

    private struct PercentageCircle: View {
        @Binding var count: Double
        var total: Double

        var body: some View {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.4), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: count / total)
                    .stroke(.customPrimary, lineWidth: 8)
                    .rotationEffect(.degrees(-90))

                Text("\(Int(count))")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .bold()
            }
        }
    }
}


//#Preview {
//    @
//    @Previewable @State var habit = HabitViewModel().getHabits(date: Date())[0]
//    HabitTrackView(info: $habit)
//}
