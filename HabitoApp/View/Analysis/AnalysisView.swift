//
//  AnalysisView.swift
//  HabitoApp
//
//  Created by Alex Cabrera on 2/12/25.
//

import SwiftUI

struct AnalysisView: View {

    @Environment(HabitViewModel.self) var habitViewModel
    @State var currentDate = Date()

    var body: some View {
        VStack {
            let waterHabit = habitViewModel.getHabits(date: currentDate)![0]
            HStack {
                Text("Drink Progress! 💦")
                Spacer()
                PercentageCircle(percentage: Double(waterHabit.habit.count) / Double(waterHabit.habit.total))
            }
            .padding()
            .background(.customLight)
            .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxHeight: 100)
                .padding(.bottom, 15)
            barCard
                .frame(maxHeight: 240)
                .padding(.bottom, 15)
            HStack {
                sleepCard
                stepCard
            }
            .frame(maxHeight: 140)
            Spacer()
        }
        .padding(.horizontal, 30)
        .task {
            currentDate = Date()
        }
    }

    var topCard: some View {
        let waterHabit = habitViewModel.getHabits(date: currentDate)![0]
        return HStack {
            Text("Drink Progress! 💦")
            Spacer()
            PercentageCircle(percentage: Double(waterHabit.habit.count) / Double(waterHabit.habit.total))
        }
        .padding()
        .background(.customLight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    var barCard: some View {
        VStack {
            HStack {
                Text("Exercise")
                Spacer()
                Text("7 Days")
            }
            barGroup
        }
        .padding()
        .background(.customLight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
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

    var barGroup: some View {
        HStack {
            ForEach(createDates(date: currentDate, num: 7), id: \.self) { date in
                let exercise = habitViewModel.getHabits(date: date)![3]
                let percentage = Double(exercise.habit.count) / Double(exercise.habit.total)
                VStack {
                    let (_, dayName) = getDateComponents(date: date)
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.customPrimary)
                                .frame(height: geometry.size.height * percentage)
                                .clipped()
                        }
                    }
                    Text(dayName)
                }
//                .frame(maxHeight: 170)
            }
        }
    }

    var sleepCard: some View {
        let sleepHabit = habitViewModel.getHabits(date: currentDate)![2]
        let percentage = Double(sleepHabit.habit.count) / Double(sleepHabit.habit.total)
        return VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text("Sleep")
                PercentageCircle(percentage: percentage)
            }
            Text("\(sleepHabit.habit.count)/\(sleepHabit.habit.total) \(sleepHabit.asset.unit.capitalized)")
        }
        .padding()
        .background(.customLight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    var stepCard: some View {
        let walkHabit = habitViewModel.getHabits(date: currentDate)![1]
        return VStack {
            Image(systemName: "figure.walk")
                .resizable()
                .scaledToFit()
            Spacer()
            Text("Walking")
                .padding(.bottom, 10)
            Text("\(walkHabit.habit.count) \(walkHabit.asset.unit.capitalized)")

        }
        .padding(.vertical)
        .padding(.horizontal, 35)
        .background(.customLight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private struct PercentageCircle: View {
        var percentage: Double

        var body: some View {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.9), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(Color.green, lineWidth: 8)
                    .rotationEffect(.degrees(-90))

                Text("\(Int(percentage * 100))%")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .bold()
            }
        }
    }
}

#Preview {
    @Previewable @AppStorage("currentID") var currentID: Int?
    let accountViewModel = AccountViewModel()
    let habitViewModel = HabitViewModel(accountViewModel: accountViewModel)

    currentID = nil

    try? KeychainManager.deleteCredentials()
    let user = try? accountViewModel.createUser(name: "test", email: "test@test.com", phone: "1236540987", password: "password")

    accountViewModel.currentUser = user

    return AnalysisView()
        .environment(accountViewModel)
        .environment(habitViewModel)
}
