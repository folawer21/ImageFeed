//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Александр  Сухинин on 02.04.2024.
//

import XCTest
import UIKit
final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }


    func testAuth() throws{
        
        let authButton = app.buttons["Authenticate"]
        authButton.tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
      

    }
    
    func testFeed() throws{
//        let tablesQuery = app.tables
//        sleep(5)
//        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        cell.swipeUp()
//        
//        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
//        let likeButton = cellToLike.buttons["LikeButton"]
//        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
//        likeButton.tap()
//        likeButton.tap()
//        
//        cellToLike.tap()
//        let image = app.scrollViews.images.element(boundBy: 0)
//        XCTAssertTrue(image.waitForExistence(timeout: 5))
//        
//        image.pinch(withScale: 3, velocity: 1)
//        image.pinch(withScale: 0.5, velocity: -1)
//        
//        let backButton = app.buttons["BackButton"]
//        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
//        
//        backButton.tap()
        let tablesQuery = app.tables

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()

        sleep(2)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

//        cellToLike.buttons["like button off"].tap()
//        cellToLike.buttons["like button on"].tap()
//
//        sleep(2)

        cellToLike.tap()

        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws{
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Alexander Sukhinin"].exists)
        XCTAssertTrue(app.staticTexts["@folawer21"].exists)
        
        app.buttons["exitButton"].tap()
        
        app.alerts["Пока, Пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
    }
}
