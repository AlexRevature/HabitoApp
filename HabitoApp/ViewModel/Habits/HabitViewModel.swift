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
        HabitInfoFull(title: "Drink", message: "Maybe more?", image: UIImage(named: "water")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "circle")!, count: 6, total: 10, unit: "glasses"),
        HabitInfoFull(title: "Walking", message: "Maybe more?", image: UIImage(named: "running")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "circle")!, count: 5, total: 10, unit: "steps"),
        HabitInfoFull(title: "Sleep", message: "Maybe more?", image: UIImage(named: "sleep")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "circle")!, count: 7, total: 10, unit: "hours"),
        HabitInfoFull(title: "Exericse", message: "Maybe more?", image: UIImage(named: "yoga")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "circle")!, count: 1, total: 10, unit: "minutes")
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
    var message: String
    var image: UIImage
    var backImage: UIImage
    var trackImage: UIImage
    var count: Int
    var total: Int
    var unit: String
}
