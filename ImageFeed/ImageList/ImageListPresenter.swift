//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.04.2024.
//

import UIKit

final class ImageListPresenter: ImageListPresenterProtocol{

    weak var view: ImageListViewControllerProtocol?
    private var imageListServiceObserver: NSObjectProtocol?
    private lazy var imageListService = ImageListService()
    
    func likeTapped(_ cell: ImagesListCell) {
        cell.setButtonAvailability(false)
        guard let tableView = view?.getTableView() else {return }
        guard let indexPath = tableView.indexPath(for: cell) else{ return }
        let photo = imageListService.photos[indexPath.row]
        let isLiked = photo.isLiked
        let id = photo.id
        imageListService.likeButtonService(id: id, isLike: isLiked){ result in
            DispatchQueue.main.async{
                switch result{
                case .success:
                    cell.changeLikeImage(!isLiked)
                case .failure(let error):
                    print(error)
                }
                cell.setButtonAvailability(true)
            }
        }
    }
    
    func fetchNewPhotos(indexPath: IndexPath) {
        if indexPath.row == (imageListService.photos.count - 1) {
            imageListService.fetchPhotosNextPage()
        }
    }
    func fetchStartPhotos(){
        imageListService.fetchPhotosNextPage()
    }
    
    func setObserverForImageList() {
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main){ [weak self] _  in
            guard let self = self else {return }
            self.view?.updateTableViewAnimated()
        }
    }
    
    func getCellHeight(indexPath: IndexPath) -> CGFloat {
        let photo = imageListService.photos[indexPath.row]
        guard let tableView = view?.getTableView() else {return 0}
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height*scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func getSingleImage(indexPath: IndexPath) -> SingleImageViewControllerCode? {
        let singleImageController  = SingleImageViewControllerCode()
        guard let url = URL(string: imageListService.photos[indexPath.row].largeImageURL) else {return nil }
        singleImageController.url = url
        singleImageController.modalPresentationStyle = .fullScreen
        return singleImageController
    }
    
    func getPhotosCount() -> Int {
        return imageListService.photos.count
    }
    
    func getPhotos() -> [Photo]{
        return imageListService.photos
    }
    
}
