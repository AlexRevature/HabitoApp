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
            UserBar(name: viewModel.userInfo?.name ?? "")
                .padding(.top, 20)

            LongNavigationButton(text: viewModel.habitGroup?.buttonText ?? "") { HabitMainView() }
            .padding(.init(top: 15, leading: 20, bottom: 5, trailing: 20))
            HabitCardView(number: $tCount, title: "Drink Water", subtitle: "Now!", image: UIImage(named: "sample")!)
                .padding(.horizontal, 20)

            LongNavigationButton(text: viewModel.challengeInfo?.buttonText ?? "") { Text("") }
            .padding(.init(top: 20, leading: 20, bottom: 5, trailing: 20))
            ChallengeCardView(dayNumber: 10, totalDays: 30, challengeTitle: "Keep Fit!", image: UIImage(named: "sample")!)
                .padding(.horizontal, 20)

            LongNavigationButton(text: viewModel.recipeInfo?.buttonText ?? "") { Text("") }
            .padding(.init(top: 20, leading: 20, bottom: 5, trailing: 20))
            RecipeCardView(image: UIImage(named: "sample")!)
                .padding(.horizontal, 20)

            LongNavigationButton(text: viewModel.guideInfo?.buttonText ?? "") { Text("") }
            .padding(.init(top: 15, leading: 20, bottom: 5, trailing: 20))
            GuideCardView(title: "This habit", subtitle: "Is Rad", image: UIImage(named: "sample")!)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)

        }
    }

}

private struct UserBar: View {

    var name: String

    var body: some View {
        VStack{
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 60, maxHeight: 60)
                VStack(alignment: .leading) {
                    Text("Good Morning, \(name)!")
                    Text("Ready to achieve your goals?")
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

//#Preview {
//    NavigationStack {
//        HomeMainView()
//    }
//}
