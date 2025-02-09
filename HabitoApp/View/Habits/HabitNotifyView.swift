//
//  HabitNotifyView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitNotifyView: View {
    var body: some View {
        VStack {
            Image(systemName: "circle")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 170)
                .padding(.bottom, 40)
            Text("You're amazing 🎉!")
                .font(.title)
                .foregroundStyle(.green)
                .padding(.bottom, 30)
            Text("You completed your habit for the day, congratulations!")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .padding(.bottom, 40)
            Button {
                print("Test")
            } label: {
                Text("Share")
                    .tint(.white)
                    .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30))
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Spacer()
        }
        .padding(.top, 50)
    }
}

#Preview {
    HabitNotifyView()
}
