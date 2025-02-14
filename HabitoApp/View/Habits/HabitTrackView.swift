//
//  HabitTrackView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitTrackView: View {

    @Binding var info: (id: Int, habit: Habit, asset: HabitAsset)
    @State var value: Double

    init(info: Binding<(id: Int, habit: Habit, asset: HabitAsset)>) {
        self._info = info
        self.value = Double(info.wrappedValue.habit.count)
    }

    var body: some View {
        VStack {
            Text(info.asset.title)
                .font(.title)
            Text(info.asset.message)

            imageStack
                .padding(.vertical, 90)
            Slider(
                value: $value,
                in: 0...Double(info.habit.total),
                step: 1
            )
            .tint(.green)
            .padding(.horizontal, 45)
            .padding(.bottom, 30)
            Button {
                print("Test")
            } label: {
                Text("Done")
                    .tint(.white)
                    .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30))
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Spacer()
        }
        .padding(.top, 80)
        .onChange(of: value) {
            info.habit.count = Int(value)
        }
    }

    var imageStack: some View {
        ZStack {
            Image(systemName: "circle")
                .resizable()
                .foregroundStyle(.blue)
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("\(info.habit.count)")
                .font(.title)
        }
    }
}


//#Preview {
//    @
//    @Previewable @State var habit = HabitViewModel().getHabits(date: Date())[0]
//    HabitTrackView(info: $habit)
//}
