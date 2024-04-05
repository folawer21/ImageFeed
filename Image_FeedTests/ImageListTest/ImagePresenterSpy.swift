//
//  ImagePresenterSpy.swift
//  Image)FeedTests
//
//  Created by Александр  Сухинин on 05.04.2024.
//

import Foundation
@testable import ImageFeed

final class ImagePresenterSpy: ImageListPresenterProtocol{
    var view: (any ImageFeed.ImageListViewControllerProtocol)?
    var didObserverSet: Bool = false
    var didLikeTapped: Bool = false
    func likeTapped(_ cell: ImagesListCell) {
        didLikeTapped = true
    }

    func setObserverForImageList() {
        didObserverSet = true
    }
    
    func fetchNewPhotos(indexPath: IndexPath) {
    }
    
    func getCellHeight(indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func getSingleImage(indexPath: IndexPath) -> SingleImageViewControllerCode? {
        return nil
    }
    
    func getPhotosCount() -> Int {
        return 0
    }
    
    func getPhotos() -> [Photo] {
        return []
    }
    
    func fetchStartPhotos() {
    }
    
    
}
