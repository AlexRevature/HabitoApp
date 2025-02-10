//
//  HabitListView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitListView: View {
    var habits: [HabitInfoFull]

    var body: some View {
        ScrollView {
            ForEach(habits) { habit in
                HabitCellView(title: habit.title, subtitle: habit.subtitle, percentage: Double(habit.count) / Double(habit.total), mainImage: habit.image, backImage: habit.backImage)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    var viewModel = HabitViewModel()
    HabitListView(habits: viewModel.getHabits(date: Date()))
}
