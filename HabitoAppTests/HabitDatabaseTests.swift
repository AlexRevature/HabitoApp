//
//  HabitDatabaseTests.swift
//  HabitoAppTests
//
//  Created by Alex Cabrera on 2/18/25.
//

import XCTest
@testable import HabitoApp

final class HabitDatabaseTests: XCTestCase {

    var dbManager: DBManager!
    var habitManager: HabitManager!

    override func setUp() {
        dbManager = DBManager(filename: "test.sqlite")
        habitManager = HabitManager(manager: dbManager)
    }

    override func tearDown() {
        dbManager.closeDatabase()
    }

    func testInsertion() throws {

        let testType = HabitType.exercise
        let testCount = 0
        let testTotal = 20
        let testDate = Date().formatted(date: .abbreviated, time: .omitted)

        let id = habitManager.insertData(type: testType, count: testCount, total: testTotal, userID: nil, date: testDate)
        let validID = try XCTUnwrap(id)

        let habit = habitManager.fetchDataById(id: validID)
        let validHabit = try XCTUnwrap(habit)

        XCTAssert(validHabit.type == testType.rawValue)
        XCTAssert(validHabit.count == testCount)
        XCTAssert(validHabit.total == testTotal)
        XCTAssert(validHabit.date == testDate)
    }

    func testUpdate() throws {
        let firstType = HabitType.water
        let firstCount = 0
        let firstTotal = 20
        let firstDate = Date().formatted(date: .abbreviated, time: .omitted)

        let newType = HabitType.exercise
        let newCount = 5
        let newTotal = 40
        let newDate = Date().formatted(date: .abbreviated, time: .omitted)

        let id = habitManager.insertData(type: firstType, count: firstCount, total: firstTotal, userID: nil, date: firstDate)
        let validID = try XCTUnwrap(id)

        habitManager.updateData(id: validID, type: newType, count: newCount, total: newTotal, userID: nil, date: newDate)

        let habit = habitManager.fetchDataById(id: validID)
        let validHabit = try XCTUnwrap(habit)

        XCTAssert(validHabit.type == newType.rawValue)
        XCTAssert(validHabit.count == newCount)
        XCTAssert(validHabit.total == newTotal)
        XCTAssert(validHabit.date == newDate)
    }

    func testDelete() throws {
        let testType = HabitType.exercise
        let testCount = 0
        let testTotal = 20
        let testDate = Date().formatted(date: .abbreviated, time: .omitted)

        let id = habitManager.insertData(type: testType, count: testCount, total: testTotal, userID: nil, date: testDate)
        let validID = try XCTUnwrap(id)

        habitManager.deleteData(id: validID)
        XCTAssertNil(habitManager.fetchDataById(id: validID))
    }

    func testInsertPerformance() throws {
        let testType = HabitType.exercise
        let testCount = 0
        let testTotal = 20
        let testDate = Date().formatted(date: .abbreviated, time: .omitted)

        self.measure {
            for _ in 0..<20 {
                _ = habitManager.insertData(type: testType, count: testCount, total: testTotal, userID: nil, date: testDate)
            }
        }
    }

}
