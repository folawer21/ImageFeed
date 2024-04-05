//
//  Image_FeedTests.swift
//  Image)FeedTests
//
//  Created by Александр  Сухинин on 01.04.2024.
//
@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {    
    func testProfileAlert(){
        let profileControllerSpy = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        profileControllerSpy.presenter = presenter
        presenter.view = profileControllerSpy
        
        presenter.logoutButtonTapped()
        
        XCTAssertTrue(profileControllerSpy.isAlertShowed)
    }
    
    func testSetObserver(){
        let profileController = ProfileViewController()
        let presenterSpy = ProfilePresenterSpy()
        profileController.presenter = presenterSpy
        presenterSpy.view = profileController
        
        profileController.setObserver()
        
        XCTAssertTrue(presenterSpy.observerDidSet)
    }

}
