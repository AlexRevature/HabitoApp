//
//  ChallengeMainView.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/13/25.
//

import SwiftUI

struct ChallengeMainView: View {

    @State var viewModel: ChallengeViewModel
    @State var initialDate: Date
    @State var selection: Date
    @State var selectedChallenges: [ChallengeInfoFull]

    init() {
        let viewModel = ChallengeViewModel()
        let currentDate = Date()
        
        self.viewModel = viewModel
        self.initialDate = currentDate
        self.selection = currentDate
        self.selectedChallenges = viewModel.getChallenges(date: currentDate)
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
            .background(Color.customAlternate)
            
            ChallengeListView(challenges: $selectedChallenges)
                .padding(.horizontal, 8)
        }
        .onChange(of: selection) { newValue in
            self.selectedChallenges = viewModel.getChallenges(date: selection)
        }
    }
    
    /// Creates an array of dates starting from `date` for `num` consecutive days.
    func createDates(date: Date, num: Int) -> [Date] {
        var dateList = [date]
        for offset in 1..<num {
            let newDate = Calendar.current.date(byAdding: .day, value: offset, to: date)
            dateList.append(newDate ?? Date())
        }
        return dateList
    }
    
    /// Returns the day number and abbreviated weekday (e.g., "Mon") for the given date.
    func getDateComponents(date: Date) -> (Int, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let weekDay = formatter.string(from: date)
        let dayNum = Calendar.current.component(.day, from: date)
        return (dayNum, weekDay)
    }
    
    /// A calendar button that overlays a hidden date picker.
    var calendarButton: some View {
        Image(systemName: "chevron.right.2")
            .tint(.black)
            .overlay {
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
}



#Preview {
    NavigationStack {
        ChallengeMainView()
    }
}
