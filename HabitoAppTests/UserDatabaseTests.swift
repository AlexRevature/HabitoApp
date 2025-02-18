//
//  UserDatabaseTests.swift
//  HabitoAppTests
//
//  Created by Alex Cabrera on 2/18/25.
//

import XCTest
@testable import HabitoApp

final class UserDatabaseTests: XCTestCase {

    var dbManager: DBManager!
    var userManager: UserManager!

    override func setUp() {
        dbManager = DBManager(filename: "test.sqlite")
        userManager = UserManager(manager: dbManager)
    }

    override func tearDown() {
        dbManager.closeDatabase()
    }

    func testInsertion() throws {

        let testName = "John User"
        let testEmail = "insert@test.com"
        let testPhone = "7245567923"

        let id = userManager.insertData(name: testName, email: testEmail, phone: testPhone)
        let validID = try XCTUnwrap(id)

        let user = userManager.fetchDataById(id: validID)
        let validUser = try XCTUnwrap(user)

        XCTAssert(validUser.name == testName)
        XCTAssert(validUser.email == testEmail)
        XCTAssert(validUser.phone == testPhone)
    }

    func testUpdate() throws {
        let firstName = "John First"
        let firstEmail = "first@test.com"
        let firstPhone = "100"

        let newName = "John Updated"
        let newEmail = "update@test.com"
        let newPhone = "200"

        let id = userManager.insertData(name: firstName, email: firstEmail, phone: firstPhone)
        let validID = try XCTUnwrap(id)

        userManager.updateData(id: validID, name: newName, email: newEmail, phone: newPhone)

        let user = userManager.fetchDataById(id: validID)
        let validUser = try XCTUnwrap(user)

        XCTAssert(validUser.name == newName)
        XCTAssert(validUser.email == newEmail)
        XCTAssert(validUser.phone == newPhone)
    }

    func testDelete() throws {
        let testName = "John User"
        let testEmail = "insert@test.com"
        let testPhone = "7245567923"

        let id = userManager.insertData(name: testName, email: testEmail, phone: testPhone)
        let validID = try XCTUnwrap(id)

        userManager.deleteData(id: validID)
        XCTAssertNil(userManager.fetchDataById(id: validID))
    }

    func testInsertPerformance() throws {
        let testName = "John User"
        let testPhone = "7245567923"

        self.measure {
            for idx in 0..<20 {
                _ = userManager.insertData(name: testName, email: "measure\(idx)@test.com", phone: testPhone)
            }
        }
    }

}
