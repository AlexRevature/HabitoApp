//
//  UserVMTests.swift
//  HabitoAppTests
//
//  Created by Alex Cabrera on 2/18/25.
//

import XCTest
@testable import HabitoApp

final class UserVMTests: XCTestCase {

    var viewModel: AccountViewModel!
    let testName = "John Test"
    let testEmail = "unit@test.com"
    let testPhone = "123456789"
    let testPassword = "password"

    override func setUp() {
        viewModel = AccountViewModel()
        viewModel.currentUser = try? viewModel.createUser(name: "Initial", email: "initial@test.com", phone: "100", password: "password")
    }

    func testValidInput() {
        XCTAssertNoThrow(try viewModel.verifyInformation(name: testName, email: testEmail, phone: testPhone, password: testPassword, passwordVerify: testPassword))
    }

    func testEmailError() throws {
        let invalidEmail = "invalid"

        XCTAssertThrowsError(try viewModel.verifyInformation(name: testName, email: invalidEmail, phone: testPhone, password: testPassword, passwordVerify: testPassword)) { error in
            guard case AccountError.email = error else {
                XCTFail()
                return
            }
        }
    }

    func testPasswordValidity() throws {
        let invalidPassword = "abc"

        XCTAssertThrowsError(try viewModel.verifyInformation(name: testName, email: testEmail, phone: testPhone, password: invalidPassword, passwordVerify: invalidPassword)) { error in
            guard case AccountError.password = error else {
                XCTFail()
                return
            }
        }
    }

    func testPasswordMatch() throws {
        let invalidVerification = "verification"

        XCTAssertThrowsError(try viewModel.verifyInformation(name: testName, email: testEmail, phone: testPhone, password: testPassword, passwordVerify: invalidVerification)) { error in
            guard case AccountError.password = error else {
                XCTFail()
                return
            }
        }
    }

    func testVerifyUser() throws {
        XCTAssertNoThrow(try viewModel.verifyUserByEmail(email: "initial@test.com", password: "password"))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
