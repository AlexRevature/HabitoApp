//
//  HabitModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import Foundation

struct Habit {
    var id: Int?
    var type: Int
    var count: Int
    var total: Int
    var userID: Int?
    var date: String

    init(id: Int? = nil, type: HabitType, count: Int, total: Int, userID: Int? = nil, date: String) {

        self.id = id
        self.type = type.rawValue
        self.count = count
        self.total = total
        self.userID = userID
        self.date = date
    }

//    static func == (lhs: Habit, rhs: Habit) -> Bool {
//        lhs.id == rhs.id && lhs.type == rhs.type
//            && lhs.count == rhs.count && lhs.total == rhs.total
//                && lhs.userID == rhs.userID && lhs.date == rhs.date
//    }
}

enum HabitType: Int, CaseIterable {
    case water
    case walking
    case sleep
    case exercise
    case invalid
}
