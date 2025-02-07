//
//  HabitMainView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitMainView: View {
    @State private var favoriteColor = 0
    var selectedItem = 1

    var body: some View {
        VStack {
            CustomPicker(sources: [1,2,3,4,5], selection: selectedItem) { item in
                VStack {
                    Text("Thu")
                    Text("15")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            HabitListView()
                .padding(.horizontal, 8)


        }
    }
}

struct CustomPicker<Data, Content>: View where Data: Hashable, Content: View {

    let sources: [Data]
    @State var selection: Data?
    let itemBuilder: (Data) -> Content
    var backgroundColor = Color.init(uiColor: .customSecondary)

    init(sources: [Data], selection: Data?, @ViewBuilder itemBuilder: @escaping (Data) -> Content) {

        self.sources = sources
        self.selection = selection
        self.itemBuilder = itemBuilder
    }

    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                ForEach(sources, id: \.self) { item in
                    itemBuilder(item)
                        .foregroundColor(selection == item ? .white : nil)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 15)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selection == item ? Color.init(uiColor: .customPrimary) : backgroundColor)
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.150)) {
                                selection = item
                            }
                        }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 6.0)
                    .fill(backgroundColor)
            )

        }
    }

    func setBackgroundColor(color: Color) ->  CustomPicker {
        var returnView = self // Value type, copied
        returnView.backgroundColor = color
        return returnView
    }
}

#Preview {
    HabitMainView()
}
