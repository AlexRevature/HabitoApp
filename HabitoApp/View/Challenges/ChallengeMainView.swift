//
//  ChallengeMainView.swift
//  HabitoApp
//
//  Created by Areeb Durrani on 2/13/25.
//

import SwiftUI

struct ChallengeMainView: View {
    @StateObject var viewModel = ChallengeViewModel()
    @Environment(AccountViewModel.self) var accountViewModel  // Added to access currentUser
    @State var initialDate: Date = Date()
    @State var selection: Date = Date()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
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
                    
                    ChallengeListView(challenges: $viewModel.challenges)
                        .padding(.horizontal, 8)
                }
                .onAppear {
                    viewModel.userId = accountViewModel.currentUser?.id
                    viewModel.refreshChallenges(for: selection)
                }
                .onChange(of: selection) { newValue in
                    viewModel.refreshChallenges(for: newValue)
                }
                // When the calendar button changes the base date, update the selection as well.
                .onChange(of: initialDate) { newValue in
                    selection = newValue
                    viewModel.refreshChallenges(for: newValue)
                }
                
                // Plus button in a green circle that navigates to ChallengeEditView.
                NavigationLink(destination: ChallengeEditView(onSave: {
                    viewModel.refreshChallenges(for: selection)
                }).environment(accountViewModel)) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.green))
                        .shadow(radius: 4)
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
        }
    }
    
    /// Creates an array of consecutive dates starting from `date` for `num` days.
    func createDates(date: Date, num: Int) -> [Date] {
        var dateList = [date]
        for offset in 1..<num {
            let newDate = Calendar.current.date(byAdding: .day, value: offset, to: date)
            dateList.append(newDate ?? Date())
        }
        return dateList
    }
    
    /// Returns the day number and abbreviated weekday for the given date.
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
                .labelsHidden()
                .blendMode(.destinationOver)
                .frame(maxWidth: 10, maxHeight: 10)
            }
    }
}

#Preview {
    NavigationStack {
        ChallengeMainView()
            .environment(AccountViewModel())
    }
}
