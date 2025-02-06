//
//  HomeMainView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HomeMainView: View {

    @State var tCount = 0

    var body: some View {
        VStack {
            UserBar(name: "John")
            LongButton(text: "Complete your daily habits!") {
                print("Help")
            }
            .padding(.init(top: 20, leading: 20, bottom: 5, trailing: 20))
            HabitCardView(number: $tCount, title: "Drink Water", subtitle: "Now!")
                .padding(.horizontal, 20)
            LongButton(text: "Keep up your challenges!") {
                print("Help")
            }
            .padding(.init(top: 20, leading: 20, bottom: 5, trailing: 20))
            ChallengeCardView(dayNumber: 10, totalDays: 30, challengeTitle: "Help")
                .padding(.horizontal, 20)
            Spacer()

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

private struct LongButton: View {

    var text: String
    var action: () -> Void

    var body: some View {
        Button (
            action: {
                action()
            },
            label: {
                HStack {
                    Text(text)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .tint(.black)
            }
        )
    }
}

#Preview {
    HomeMainView()
}
