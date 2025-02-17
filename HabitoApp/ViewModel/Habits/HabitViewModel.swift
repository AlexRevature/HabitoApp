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

    var currentHabits: [HabitPacket] = [] {
        didSet {
            print("Changes")
        }
    }


    var accountViewModel: AccountViewModel?

    init(accountViewModel: AccountViewModel? = nil) {
        self.accountViewModel = accountViewModel
        setHabits(date: Date())
    }

    let habitAssets: [HabitType:HabitAsset] = [
        .water: HabitAsset(name: "Water", title: "Water", message: "Almost there!", image: "water", backImage: "back", trackImage: nil, unit: "glasses"),
        .walking: HabitAsset(name: "Walking", title: "Walking", message: "Keep going!", image: "running", backImage: "back", trackImage: nil, unit: "steps"),
        .sleep: HabitAsset(name: "Sleep", title: "Sleep", message: "Doing well!", image: "sleep", backImage: "back", trackImage: nil, unit: "hours"),
        .exercise: HabitAsset(name: "Exercise", title: "Exercise", message: "You can do it!", image: "yoga", backImage: "back", trackImage: nil, unit: "minutes"),
    ]

    func getHabits(date: Date) -> [HabitPacket]? {
        var habitList = [HabitPacket]()

        guard let currentUser = accountViewModel?.currentUser else {
            habitList = getEmptyHabits(id: nil, date: date)
            return habitList
        }

        let habits = HabitManager.shared.fetchDataByUserDate(userID: currentUser.id, date: date.formatted(date: .numeric, time: .omitted))
        guard let habits else {
            habitList = getEmptyHabits(id: currentUser.id, date: date)
            return habitList
        }

        for (idx, habit) in habits.enumerated() {
            guard let type = HabitType(rawValue: habit.type) else { continue }
            guard let asset = habitAssets[type] else { continue }
            habitList.append(HabitPacket(id: idx, habit: habit, asset: asset))
        }

        return habitList
    }

    func setHabits(date: Date) {
        let habitList = getHabits(date: date)
        if let habitList {
            currentHabits = habitList
        }
    }

    func getEmptyHabits(id: Int?, date: Date) -> [HabitPacket] {
        var habitList = [HabitPacket]()
        var itemCount = 0
        for type in HabitType.allCases {
            guard let asset = habitAssets[type] else { continue }
            
            let total = switch type {
                case .water:
                    10
                case .walking:
                    1000
                case .sleep:
                    8
                case .exercise:
                    25
                default:
                    0
            }
            habitList.append(HabitPacket(id: itemCount, habit: Habit(type: type, count: 0, total: total, userID: id, date: date.formatted(date: .numeric, time: .omitted)), asset: asset))
            itemCount += 1
        }

        return habitList
    }

    func saveHabits() {
        guard let currentUser = accountViewModel?.currentUser else {
            return
        }
        for packet in currentHabits {
            let habit = packet.habit
            if let id = habit.id {
                HabitManager.shared.updateData(id: id, type: HabitType(rawValue: habit.type)!, count: habit.count, total: habit.total, userID: currentUser.id, date: habit.date)
            } else {
                let id = HabitManager.shared.insertData(type: HabitType(rawValue: habit.type)!, count: habit.count, total: habit.total, userID: currentUser.id, date: habit.date)
                packet.habit.id = id
            }
        }
    }
}

@Observable
class HabitPacket: Identifiable {
    var id: Int
    var habit: Habit
    var asset: HabitAsset

    init(id: Int, habit: Habit, asset: HabitAsset) {
        self.id = id
        self.habit = habit
        self.asset = asset
    }

//    static func == (lhs: HabitPacket, rhs: HabitPacket) -> Bool {
//        lhs.id == rhs.id && lhs.habit == rhs.habit
//            && lhs.asset == rhs.asset
//    }

}

struct HabitAsset {
    var name: String
    var title: String
    var message: String
    var image: String
    var backImage: String
    var trackImage: String?
    var unit: String

    init(name: String, title: String, message: String, image: String, backImage: String, trackImage: String? = nil, unit: String) {
        self.name = name
        self.title = title
        self.message = message
        self.image = image
        self.backImage = backImage
        self.trackImage = trackImage
        self.unit = unit
    }

//    static func == (lhs: HabitAsset, rhs: HabitAsset) -> Bool {
//        lhs.title == rhs.title
//    }
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
