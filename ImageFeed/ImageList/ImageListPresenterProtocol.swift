//
//  ImageListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.04.2024.
//

import UIKit
protocol ImageListPresenterProtocol: AnyObject{
    var view: ImageListViewControllerProtocol? {get set }
    
    func likeTapped(_ cell: ImagesListCell)
    func fetchNewPhotos(indexPath: IndexPath)
    func setObserverForImageList()
    func getCellHeight(indexPath: IndexPath) -> CGFloat
    func getSingleImage(indexPath: IndexPath) ->SingleImageViewControllerCode?
    func getPhotosCount() -> Int
    func getPhotos() -> [Photo]
    func fetchStartPhotos()
}
