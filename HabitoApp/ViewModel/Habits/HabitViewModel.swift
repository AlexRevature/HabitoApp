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

    var currentHabits: [(id: Int, habit: Habit, asset: HabitAsset)]?
    var accountViewModel: AccountViewModel

    init(accountViewModel: AccountViewModel) {
        self.accountViewModel = accountViewModel
        setActualHabits(date: Date())
    }

    let habitAssets: [HabitType:HabitAsset] = [
        .water: HabitAsset(title: "Drink", message: "Maybe more?", image: "water", backImage: "back", trackImage: nil, unit: "glasses"),
        .walking: HabitAsset(title: "Walking", message: "Maybe more?", image: "running", backImage: "back", trackImage: nil, unit: "steps"),
        .sleep: HabitAsset(title: "Sleep", message: "Maybe more?", image: "sleep", backImage: "back", trackImage: nil, unit: "hoours"),
        .exercise: HabitAsset(title: "Exercise", message: "Maybe more?", image: "yoga", backImage: "back", trackImage: nil, unit: "minutes"),
    ]


    let testHabits = [
        HabitInfoFull(title: "Drink", message: "Maybe more?", image: UIImage(named: "water")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "circle")!, count: 6, total: 10, unit: "glasses"),
        HabitInfoFull(title: "Walking", message: "Maybe more?", image: UIImage(named: "running")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "circle")!, count: 5, total: 10, unit: "steps"),
        HabitInfoFull(title: "Sleep", message: "Maybe more?", image: UIImage(named: "sleep")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "circle")!, count: 7, total: 10, unit: "hours"),
        HabitInfoFull(title: "Exericse", message: "Maybe more?", image: UIImage(named: "yoga")!, backImage: UIImage(named: "back")!, trackImage: UIImage(systemName: "circle")!, count: 1, total: 10, unit: "minutes")
    ]

    func getHabits(date: Date) -> [HabitInfoFull] {
        return getTestHabits(date: date)
    }

    func setActualHabits(date: Date) {
        var habitList = [(Int, Habit, HabitAsset)]()

        guard let currentUser = accountViewModel.currentUser else {
            currentHabits = getEmptyHabits(id: nil, date: date)
            return
        }

        let habits = HabitManager.shared.fetchDataByUserDate(userID: currentUser.id, date: date.formatted(date: .numeric, time: .omitted))
        guard let habits else {
            currentHabits = getEmptyHabits(id: currentUser.id, date: date)
            return
        }

        for (idx, habit) in habits.enumerated() {
            guard let type = HabitType(rawValue: habit.type) else { continue }
            guard let asset = habitAssets[type] else { continue }
            habitList.append((idx, habit, asset))
        }

        currentHabits = habitList
    }

    func getTestHabits(date: Date) -> [HabitInfoFull] {
        let dayNum = Calendar.current.component(.day, from: date)
        let index = dayNum % testHabits.count

        return Array(testHabits[index...] + testHabits[..<index])
    }

    func getEmptyHabits(id: Int?, date: Date) -> [(Int, Habit, HabitAsset)] {
        var habitList = [(Int, Habit, HabitAsset)]()
        var itemCount = 0
        for type in HabitType.allCases {
            guard let asset = habitAssets[type] else { continue }
            
            let total = switch type {
                case .water:
                    10
                case .walking:
                    15
                case .sleep:
                    20
                case .exercise:
                    25
                default:
                    0
            }
            habitList.append((itemCount, Habit(type: type, count: 0, total: total, userID: id, date: date.formatted(date: .numeric, time: .omitted)), asset))
            itemCount += 1
        }

        return habitList
    }
}

struct HabitAsset {
    var title: String
    var message: String
    var image: String
    var backImage: String
    var trackImage: String?
    var unit: String
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
