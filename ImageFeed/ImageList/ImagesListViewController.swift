//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 08.01.2024.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    var photos: [Photo] = []
    private lazy var imageListService = ImageListService()
    private var imageListServiceObserver: NSObjectProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath){
        let photo = photos[indexPath.row]
        let urlString = photo.thumbImageURL
        let url = URL(string:urlString)
        cell.imageCell.kf.setImage(with: url) { [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.imageCell.kf.indicatorType = .activity
        cell.dateLabel.text = photo.createdAt
//        let likedImage = photo.isLiked ? UIImage(named:"likedOn") : UIImage(named: "likedOff")
        let likedImage = UIImage(named:"likedOn")
        cell.likeButton.setImage(likedImage, for: .normal)
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        imageListService.fetchPhotosNextPage()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main){ [weak self] _  in
            guard let self = self else {return }
            self.updateTableViewAnimated()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func updateTableViewAnimated(){
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map{i in
                    IndexPath(row: i, section: 0)}
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}


extension ImagesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)-> CGFloat{
        let photo = imageListService.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height*scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
       }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (imageListService.photos.count - 1) {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            print("Cannot convert to ImageListCell")
            return UITableViewCell()
        }
        configCell(for: imageListCell,with: indexPath)
        return imageListCell
        
    }
    
}


