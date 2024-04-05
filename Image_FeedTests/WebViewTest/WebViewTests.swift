//
//  Image_FeedTests.swift
//  Image)FeedTests
//
//  Created by Александр  Сухинин on 01.04.2024.
//
@testable import ImageFeed
import XCTest

final class Image_FeedTests: XCTestCase {

    func testViewControllerCallsViewDidLoad(){
        //given
        let viewController = WebViewViewController()
        let presenterSpy = WebViewPresenterSpy()
        presenterSpy.view = viewController
        viewController.presenter = presenterSpy
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenterSpy.viewDidCallCalled)
    }
    
    func testPresenterCallsLoadRequest(){
        //given
        let viewController = WebViewViewContollerSpy()
        let authHelper = AuthHelper(configuration: AuthConfiguration.standart)
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
       
        //when
        presenter.viewDidLoad()
    
        //then
        XCTAssertTrue(viewController.didLoadCalled)
    }
    
    func testProgressVisibleWhenLessThenOne(){
        //given
        let authHelper = AuthHelper(configuration: AuthConfiguration.standart)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressVisibleWhenOne(){
        //given
        let authHelper = AuthHelper(configuration: AuthConfiguration.standart)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL(){
        //given
        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()!
        let urlString = url.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL(){
        //given
        let authHelper = AuthHelper(configuration: AuthConfiguration.standart)
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code,"test code")
    }
}
