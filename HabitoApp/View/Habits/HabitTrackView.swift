//
//  HabitTrackView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitTrackView: View {

    @Binding var info: HabitInfoFull
    @State var value: Double

    init(info: Binding<HabitInfoFull>) {
        self._info = info
        self.value = Double(info.wrappedValue.count)
    }

    var body: some View {
        VStack {
            Text(info.title)
                .font(.title)
            Text(info.subtitle)
                .padding(.bottom, 100)
            Image(uiImage: info.trackImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
                .padding(.bottom, 70)
            Slider(
                    value: $value,
                    in: 0...Double(info.total),
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
        .onChange(of: value) {
            info.count = Int(value)
        }
    }
}

//#Preview {
//    HabitTrackView(mainMessage: "Main message", secondaryMessage: "Secondary message", image: UIImage(systemName: "square")!, currentValue: 0, totalValue: 20)
//}
