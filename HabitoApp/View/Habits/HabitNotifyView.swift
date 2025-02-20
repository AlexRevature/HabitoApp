//
//  HabitNotifyView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitNotifyView: View {

    @Binding var isShown: Bool

    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .foregroundStyle(.green)
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
                isShown = false
            } label: {
                Text("Dismiss")
                    .tint(.white)
                    .padding(EdgeInsets(top: 12, leading: 40, bottom: 12, trailing: 40))
                    .background(.customPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            Spacer()
        }
        .padding(.top, 50)
    }
}

#Preview {
    @Previewable @State var isShown = true
    HabitNotifyView(isShown: $isShown)
}
