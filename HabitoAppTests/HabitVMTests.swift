//
//  HabitVMTests.swift
//  HabitoAppTests
//
//  Created by Alex Cabrera on 2/18/25.
//

import XCTest
@testable import HabitoApp

final class HabitVMTests: XCTestCase {

    var accountViewModel: AccountViewModel!
    var habitViewModel: HabitViewModel!

    override func setUp() {
        try? KeychainManager.deleteCredentials()
        accountViewModel = AccountViewModel()
        habitViewModel = HabitViewModel(accountViewModel: accountViewModel)
    }

    func testEmptyHabit() throws {
        let habitPackets = habitViewModel.getEmptyHabits(id: nil, date: Date())
        XCTAssert(habitPackets.count > 0)

        for packet in habitPackets {
            XCTAssert(packet.habit.count == 0)
            XCTAssert(packet.habit.total != 0)
            XCTAssert(packet.habit.userID == nil)
        }
    }

    func testSaveHabits() throws {

        let currentDate = Date()

        accountViewModel.currentUser = try accountViewModel.createUser(name: "Test", email: "test@test.com", phone: "432432", password: "password")
        habitViewModel.setHabits(date: currentDate)
        habitViewModel.saveHabits()

        guard let userID = accountViewModel.currentUser?.id else {
            XCTFail()
            return
        }

        let habitPackets = habitViewModel.getEmptyHabits(id: userID, date: currentDate)
        XCTAssert(habitPackets.count > 0)

        for packet in habitPackets {
            XCTAssert(packet.habit.userID == userID)
        }
    }

}
