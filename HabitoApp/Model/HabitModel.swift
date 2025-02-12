//
//  HabitModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import Foundation

class Habit {
    var id: Int
    var title: String
    var message: String
    var image: Data
    var backImage: Data
    var trackImage: Data
    var count: Int
    var total: Int
    var unit: String
    var userID: Int
    var date: String

    init(id: Int, title: String, message: String, image: Data, backImage: Data, trackImage: Data, count: Int, total: Int, unit: String, userID: Int, date: String) {

        self.id = id
        self.title = title
        self.message = message
        self.image = image
        self.backImage = backImage
        self.trackImage = trackImage
        self.count = count
        self.total = total
        self.unit = unit
        self.userID = userID
        self.date = date
    }
}
