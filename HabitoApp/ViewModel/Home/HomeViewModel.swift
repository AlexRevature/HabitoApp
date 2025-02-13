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
            greeting: "Good morning",
            message: "Welcome back!"
        )

        habitGroup = HabitCardInfo(
            buttonText: "View your habits",
            habitInfoList: [
                HomeHabitInfo(title: "Drink water", subtitle: "Now!", image: UIImage(named: "back")!, count: 0, total: 10),
                HomeHabitInfo(title: "Do Something", subtitle: "Now!", image: UIImage(named: "sample")!, count: 0, total: 10)
            ]
        )

        challengeInfo = ChallengeCardInfo(
            buttonText: "Keep up your challenges!",
            challengeText: "Keep fit!",
            dayNumber: 5,
            totalDays: 30,
            image: UIImage(named: "back")!,
            isComplete: false
        )

        recipeInfo = RecipeCardInfo(
            buttonText: "View some recipes",
            imageList: [UIImage(named: "back")!]
        )

        guideInfo = GuideCardInfo(
            buttonText: "Browse available guides!",
            title: "Test Guide",
            subtitle: "To do well",
            image: UIImage(named: "back")!
        )
    }

}

struct UserBarInfo {
    var name: String
    var image: UIImage
    var greeting: String
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
    var count: Int
    var total: Int
}

struct ChallengeCardInfo {
    var buttonText: String
    var challengeText: String
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
