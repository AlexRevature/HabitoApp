//
//  HomeViewModel.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

@Observable
class HomeViewModel {

    var userInfo: UserBarInfo?
    var habitGroup: HabitCardInfo?
    var challengeInfo: ChallengeCardInfo?
    var recipeInfo: RecipeCardInfo?
    var guideInfo: GuideCardInfo?

    init() {
        fillTestInfo()
    }

    private func fillTestInfo() {
        userInfo = UserBarInfo(
            name: "John Swift",
            image: UIImage(systemName: "person.circle")!,
            message: "Welcome back yo!"
        )

        habitGroup = HabitCardInfo(
            buttonText: "Follow new habits!",
            habitInfoList: [
                HomeHabitInfo(title: "Drink water", subtitle: "Now!", image: UIImage(named: "sample")!, count: 0)
            ]
        )

        challengeInfo = ChallengeCardInfo(
            buttonText: "Keep up your challenges!",
            dayNumber: 5,
            totalDays: 30,
            image: UIImage(named: "sample")!,
            isComplete: false
        )

        recipeInfo = RecipeCardInfo(
            buttonText: "Try some healthy recipes!",
            imageList: [UIImage(named: "sample")!]
        )

        guideInfo = GuideCardInfo(
            buttonText: "Look at some guides!",
            title: "Test Guide",
            subtitle: "To do well",
            image: UIImage(named: "sample")!
        )
    }

}

struct UserBarInfo {
    var name: String
    var image: UIImage
    var message: String
}

struct HabitCardInfo {
    var buttonText: String
    var habitInfoList: [HomeHabitInfo]
}

struct HomeHabitInfo: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var image: UIImage
    @State var count: Int
}

struct ChallengeCardInfo {
    var buttonText: String
    var dayNumber: Int
    var totalDays: Int
    var image: UIImage
    var isComplete: Bool
}

struct RecipeCardInfo {
    var buttonText: String
    var imageList: [UIImage]
}

struct GuideCardInfo {
    var buttonText: String
    var title: String
    var subtitle: String
    var image: UIImage
}
