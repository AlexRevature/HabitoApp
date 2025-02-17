//
//  HabitMainView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/6/25.
//

import SwiftUI

struct HabitMainView: View {

    @State var initialDate: Date
    @State var selection: Date

    @Environment(HabitViewModel.self) var habitViewModel

    init() {
        let currentDate = Date()
        self.initialDate = currentDate
        self.selection = currentDate
    }

    var body: some View {

        VStack {
            HStack {
                let source = createDates(date: initialDate, num: 5)
                CustomPicker(sources: source, selection: $selection) { item in
                    VStack {
                        let (dayNum, weekDay) = getDateComponents(date: item)
                        Text(weekDay)
                        Text("\(dayNum)")
                    }
                }
                calendarButton
                    .padding(.leading, 7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(.customAlternate)

            listView
                .padding(.horizontal, 8)

        }
        .onChange(of: selection) {
            print("Refresh")
            habitViewModel.setActualHabits(date: selection)
        }


    }

    func createDates(date: Date, num: Int) -> [Date] {
        var dateList = [date]
        for num in (1..<num) {
            let newDate = Calendar.current.date(byAdding: .day, value: num, to: date)
            dateList.append(newDate ?? Date())
        }
        return dateList
    }

    func getDateComponents(date: Date) -> (Int, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let weekDay = formatter.string(from: date)
        let dayNum = Calendar.current.component(.day, from: date)

        return (dayNum, weekDay)
    }

    var calendarButton: some View {

        Image(systemName: "chevron.right.2")
            .tint(.black)
            .overlay {
                // Hacky, gets a date picker, blends it with
                // image so that it is hidden, and is clipped
                // to better follow image boundaries
                DatePicker(
                     "",
                     selection: $initialDate,
                     displayedComponents: [.date]
                )
                .contentShape(Circle())
                .blendMode(.destinationOver)
                .frame(maxWidth: 10, maxHeight: 10)
            }
    }

    var listView: some View {

        @Bindable var habitViewModel = habitViewModel
        return ScrollView {
            ForEach($habitViewModel.currentHabits) { habit in
                HabitCellView(info: habit)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 10)
            }
        }
    }
}

struct CustomPicker<Data, Content>: View where Data: Hashable, Content: View {

    let sources: [Data]
    @Binding var selection: Data
    let itemBuilder: (Data) -> Content
    var backgroundColor = Color.init(uiColor: .customAlternate)

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
            .padding(.vertical, 5)
        }
        .onChange(of: sources) {
            selection = sources[0]
        }
    }

    func setBackgroundColor(color: Color) ->  CustomPicker {
        var returnView = self // Value type, copied
        returnView.backgroundColor = color
        return returnView
    }
}

#Preview {
    let accountViewModel = AccountViewModel()
    let habitViewModel = HabitViewModel(accountViewModel: accountViewModel)

    return NavigationStack {
        HabitMainView()
    }
    .environment(accountViewModel)
    .environment(habitViewModel)
}
