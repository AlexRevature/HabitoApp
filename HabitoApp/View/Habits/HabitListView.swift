//
//  HabitListView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitListView: View {
    var body: some View {
        ScrollView {
            ForEach(0..<4) { idx in
                HabitCellView(title: "Test \(idx)", subtitle: "Subtitle", percentage: 0.5, mainImage: UIImage(systemName: "square")!, backImage: UIImage(named: "back")!)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    HabitListView()
}
