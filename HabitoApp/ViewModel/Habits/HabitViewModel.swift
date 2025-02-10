//
//  HabitViewModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

//import Foundation
import SwiftUI

@Observable
class HabitViewModel {

    let testHabits = [
        HabitInfoFull(title: "Drink Water", subtitle: "Maybe more?", image: UIImage(systemName: "square")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "square")!, count: 5, total: 10),
        HabitInfoFull(title: "Drink Wine", subtitle: "Maybe more?", image: UIImage(systemName: "square")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "square")!, count: 5, total: 10),
        HabitInfoFull(title: "Drink Soda", subtitle: "Maybe more?", image: UIImage(systemName: "square")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "square")!, count: 5, total: 10),
        HabitInfoFull(title: "Drink Juice", subtitle: "Maybe more?", image: UIImage(systemName: "square")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "square")!, count: 5, total: 10)
    ]

    // Note: Time should be stripped from the date
    func getHabits(date: Date) -> [HabitInfoFull] {
        return getTestHabits(date: date)
    }

    func getTestHabits(date: Date) -> [HabitInfoFull] {
        let dayNum = Calendar.current.component(.day, from: date)
        let index = dayNum % testHabits.count

        return Array(testHabits[index...] + testHabits[..<index])
    }
}

struct HabitInfoFull: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var image: UIImage
    var backImage: UIImage
    var trackImage: UIImage
    var count: Int
    var total: Int
}
