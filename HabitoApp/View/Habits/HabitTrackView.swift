//
//  HabitTrackView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitTrackView: View {

    var mainMessage: String
    var secondaryMessage: String
    var image: UIImage

    @State var value = 0.0

    var body: some View {
        VStack {
            Text("Main message")
                .font(.title)
            Text("Secondary message")
                .padding(.bottom, 100)
            Image(systemName: "square")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
                .padding(.bottom, 70)
            Slider(
                    value: $value,
                    in: 0...20,
                    step: 1
                )
                .tint(.green)
                .padding(.horizontal, 45)
                .padding(.bottom, 30)
            Button {
                print("Test")
            } label: {
                Text("Done")
                    .tint(.white)
                    .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 30))
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Spacer()
        }
        .padding(.top, 80)
    }
}

#Preview {
    HabitTrackView(mainMessage: "Main message", secondaryMessage: "Secondary message", image: UIImage(systemName: "square")!)
}
