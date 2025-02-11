//
//  HabitListView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitListView: View {
    @Binding var habits: [HabitInfoFull]

    var body: some View {
        ScrollView {
            ForEach($habits) { habit in
                HabitCellView(info: habit)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 10)
            }
        }
    }
}

//#Preview {
//    let viewModel = HabitViewModel()
//    HabitListView(habits: viewModel.getHabits(date: Date()))
//}
