//
//  HomeMainView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HomeMainView: View {

    @State var tCount = 0
    @State var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            UserBar(userInfo: viewModel.userInfo)
                .padding(.top, 20)

            habitStack(buttonText: viewModel.habitGroup!.buttonText, habitList: Binding($viewModel.habitGroup)!.habitInfoList)

            challengeStack(info: viewModel.challengeInfo!)
            recipeStack(info: viewModel.recipeInfo!)
            guideStack(info: viewModel.guideInfo!)

        }
    }

    func habitStack(buttonText: String, habitList: Binding<[HomeHabitInfo]>) -> some View {
        VStack {
            LongNavigationButton(text: buttonText) { HabitMainView() }
                .padding(.init(top: 15, leading: 20, bottom: 5, trailing: 20))
            HabitCardView(habitInfoList: habitList)
                .padding(.horizontal, 20)
        }
    }

    func challengeStack(info: ChallengeCardInfo) -> some View {
        VStack {
            LongNavigationButton(text: info.buttonText) { Text("") }
            .padding(.init(top: 20, leading: 20, bottom: 5, trailing: 20))
            ChallengeCardView(dayNumber: info.dayNumber, totalDays: info.totalDays, challengeTitle: info.challengeText, image: info.image)
                .padding(.horizontal, 20)
        }
    }

    func recipeStack(info: RecipeCardInfo) -> some View {
        VStack {
            LongNavigationButton(text: info.buttonText) { Text("") }
            .padding(.init(top: 20, leading: 20, bottom: 5, trailing: 20))
            RecipeCardView(image: info.imageList.first!)
                .padding(.horizontal, 20)
        }
    }

    func guideStack(info: GuideCardInfo) -> some View {
        VStack {
            LongNavigationButton(text: info.buttonText) { Text("") }
            .padding(.init(top: 15, leading: 20, bottom: 5, trailing: 20))
            GuideCardView(title: info.title, subtitle: info.subtitle, image: info.image)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
        }
    }

}

private struct UserBar: View {

    var userInfo: UserBarInfo?

    var body: some View {
        VStack{
            HStack {
                Image(uiImage: userInfo?.image ?? UIImage(systemName: "person.circle")!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 60, maxHeight: 60)
                VStack(alignment: .leading) {
                    Text("\(userInfo?.greeting ?? "No greeting"), \(userInfo?.name ?? "No Name")!")
                    Text(userInfo?.message ?? "No message")
                }
                .padding(.leading, 12)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
        }
    }
}

private struct LongNavigationButton <Destination>: View where Destination: View {

    var text: String
    var destination: () -> Destination

    init(text: String, @ViewBuilder destination: @escaping () -> Destination) {
        self.text = text
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(text)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .tint(.black)
        }
        .zIndex(1)
    }
}

#Preview {
    NavigationStack {
        HomeMainView()
    }
}
