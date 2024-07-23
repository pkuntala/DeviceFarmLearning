//
//  LogicPageTests.swift
//  SuperheroesUITests
//
//  Created by Chris Davis J on 05/01/22.
//

import XCTest

class LogicPageTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
        func testLogin() throws{
            let app=XCUIApplication()
            if(!app.navigationBars["Superheroes.LoginTableView"].exists){
                return
            }
            let tablesQuery = app.tables
            let userTextField=tablesQuery/*@START_MENU_TOKEN@*/.textFields["User ID"]/*[[".cells",".textFields[\"Enter your user Id\"]",".textFields[\"User ID\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
            userTextField.tap()
            userTextField.typeText("tonystark")
            let passwordSecureTextField = tablesQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells",".secureTextFields[\"Enter your password\"]",".secureTextFields[\"Password\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
            passwordSecureTextField.tap()
            passwordSecureTextField.typeText("Kakinada")
            tablesQuery/*@START_MENU_TOKEN@*/.buttons["Login button"]/*[[".cells",".buttons[\"Login\"]",".buttons[\"Login button\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
            XCTAssertTrue(app.navigationBars["Superheroes.HospitalListTableView"].exists)
    }
    func testScrollable() throws{
        try? testLogin()
        let app = XCUIApplication()
        app.swipeUp()
    }
    func testDetailView() throws{
        let app=XCUIApplication()
        try? testLogin()
        XCTAssertTrue(app.tables.descendants(matching: .cell).firstMatch.isHittable)
        app.tables.descendants(matching: .cell).firstMatch.tap()
        XCTAssertTrue(app.navigationBars["Superheroes.DetailHospitalTableView"].exists)
        XCTAssertTrue(app.buttons.matching(identifier: "MapButton").firstMatch.isHittable)
        app.buttons.matching(identifier: "MapButton").firstMatch.tap()
        XCTAssertTrue(app.navigationBars["Superheroes.MapView"].exists)
    }
    
    func testUserProfile() throws{
        let app=XCUIApplication()
        try? testLogin()
        XCTAssertTrue(app.navigationBars["Superheroes.HospitalListTableView"].buttons.firstMatch.isHittable)
        
        app.navigationBars["Superheroes.HospitalListTableView"].buttons.firstMatch.tap()
        XCTAssertTrue(app.navigationBars["Superheroes.UserProfileView"].exists)
        XCTAssertTrue(app.buttons["Update DP"].isHittable)
        XCTAssertTrue(app.buttons["Logout"].isHittable)
        XCTAssertTrue(app.buttons["Upload Reports"].isHittable)
        app.buttons["Logout"].tap()
        XCTAssertTrue(app.navigationBars["Superheroes.LoginTableView"].exists)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /*
    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }*/

}
