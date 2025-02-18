//
//  AccountUITests.swift
//  HabitoAppUITests
//
//  Created by Alex Cabrera on 2/18/25.
//

import XCTest

final class AccountUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testUISignUp() throws {
        let app = XCUIApplication()
        app.launch()
        var doesExist = false

        let navigationLink = app.buttons["guideSignUpButton"]
        doesExist = navigationLink.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        navigationLink.tap()

        let nameField = app.textFields["signUpNameField"]
        doesExist = nameField.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        nameField.tap()
        nameField.typeText("Test User")

        let emailField = app.textFields["signUpEmailField"]
        doesExist = emailField.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        emailField.tap()
        emailField.typeText("uitest@test.com")

        let phoneField = app.textFields["signUpPhoneField"]
        doesExist = phoneField.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        phoneField.tap()
        phoneField.typeText("43253754")

        let passwordField = app.secureTextFields["signUpPasswordField"]
        doesExist = passwordField.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        passwordField.tap()
        passwordField.typeText("password1#")

        let verifyField = app.secureTextFields["signUpVerifyField"]
        doesExist = verifyField.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        verifyField.tap()
        verifyField.typeText("password1#")

        let termsButton = app.buttons["signUpTermsButton"]
        doesExist = termsButton.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        termsButton.tap()

        let mainButton = app.buttons["signUpMainButton"]
        doesExist = mainButton.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        mainButton.tap()

        sleep(5)
    }

    func testUISignIn() throws {
        let app = XCUIApplication()
        app.launch()
        var doesExist = false

        let navigationLink = app.buttons["guideSignInButton"]
        doesExist = navigationLink.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        navigationLink.tap()

        let emailField = app.textFields["signInEmailField"]
        doesExist = emailField.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        emailField.tap()
        emailField.typeText("uitest@test.com")

        let passwordField = app.secureTextFields["signInPasswordField"]
        doesExist = passwordField.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        passwordField.tap()
        passwordField.typeText("password1#")

        let mainButton = app.buttons["signInMainButton"]
        doesExist = mainButton.waitForExistence(timeout: 10)
        if !doesExist {
            XCTFail()
        }
        mainButton.tap()

        sleep(5)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
