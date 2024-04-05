//
//  ImageListViewControllerTests.swift
//  Image)FeedTests
//
//  Created by Александр  Сухинин on 05.04.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListViewControllerTests: XCTestCase {
    func testLikeButtonTapped(){
        let controller = ImagesListViewController()
        let presenter = ImagePresenterSpy()
        controller.presenter = presenter
        presenter.view = controller
        let cell = ImagesListCell()
        
        controller.likeButtontapped(cell: cell)
        
        XCTAssertTrue(presenter.didLikeTapped)
    }
    
    func testSetObserver(){
        let controller = ImagesListViewController()
        let presenter = ImagePresenterSpy()
        controller.presenter = presenter
        presenter.view = controller
        
        controller.setObserver()
        
        XCTAssertTrue(presenter.didObserverSet)
    }
    
}
