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

    @Environment(AccountViewModel.self) var accountViewModel
    @Environment(HabitViewModel.self) var habitViewModel

    var body: some View {
        ScrollView {
            userBar
                .padding(.top, 20)

            habitStack
            challengeStack
            guideStack

        }
    }

    var userBar: some View {
        VStack{
            HStack {
                getUserImage()
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 60, maxHeight: 60)
                VStack(alignment: .leading) {
                    Text("Hello, \(accountViewModel.currentUser?.name ?? "No Name")!")
                    Text("Welcome back!")
                }
                .padding(.leading, 12)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
        }
    }

    var habitStack: some View {
        VStack {
            LongNavigationButton(text: "View all your habits") { HabitMainView() }
                .padding(.init(top: 15, leading: 20, bottom: 5, trailing: 20))
            HabitCardView()
                .padding(.horizontal, 20)
        }
    }

    var challengeStack: some View {
        VStack {
            LongNavigationButton(text: "View all your challenges") { Text("") }
            .padding(.init(top: 20, leading: 20, bottom: 5, trailing: 20))
            ChallengeCardView(dayNumber: 0, totalDays: 10, challengeTitle: "Weight Lifting", image: UIImage(named: "back")!)
                .padding(.horizontal, 20)
        }
    }
//
    var guideStack: some View {
        VStack {
            LongNavigationButton(text: "View available guides") { Text("") }
            .padding(.init(top: 15, leading: 20, bottom: 5, trailing: 20))
            GuideCardView(title: "Learn new skills!", subtitle: "And some more", image: UIImage(named: "back")!)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
        }
    }

    func getUserImage() -> Image {
        if accountViewModel.currentUser?.image == nil {
            Image(systemName: "person.circle")
        } else {
            if let uiImage = UIImage(data: accountViewModel.currentUser!.image!) {
                Image(uiImage: uiImage)
            } else {
                Image(systemName: "person.circle")
            }
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
    let accountViewModel = AccountViewModel()
    let habitViewModel = HabitViewModel(accountViewModel: accountViewModel)

    return NavigationStack {
        HomeMainView()
            .environment(accountViewModel)
            .environment(habitViewModel)
    }
}
