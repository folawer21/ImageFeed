//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 08.01.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController & ImageListViewControllerProtocol {
//    @IBOutlet private var tableView: UITableView!
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.separatorColor = UIColor(named: "YPBlack")
        tableView.backgroundColor = UIColor(named: "YPBlack")
        return tableView
    }()
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    var photos: [Photo] = []
    var presenter: ImageListPresenterProtocol?
//    private lazy var imageListService = ImageListService()
//    private var imageListServiceObserver: NSObjectProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    func getTableView() -> UITableView {
        tableView
    }
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath){
        guard let photo = presenter?.getPhotos()[indexPath.row] else {return }  /*photos[indexPath.row]*/
        let urlString = photo.thumbImageURL
        guard let url = URL(string:urlString) else {return }
        let isLiked = photo.isLiked
        let date = photo.createdAt
        cell.configCell(photoUrl: url, isLiked: isLiked, date: date)
        cell.delegate = self
        
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YPBlack")
        tableView.delegate = self
        tableView.dataSource = self
        presenter?.setObserverForImageList()
        addSubViews()
        applyConstraints()
        print(presenter)
        
        presenter?.fetchStartPhotos()
//        imageListService.fetchPhotosNextPage()
        
        presenter?.setObserverForImageList()
//        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main){ [weak self] _  in
//            guard let self = self else {return }
//            self.updateTableViewAnimated()
//        }
    }
    func addSubViews(){
        view.addSubview(tableView)
    }
    func applyConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    func updateTableViewAnimated(from: Int, to: Int){
        //TODO: Переделать с презентером тоже
//        let oldCount = photos.count
//        guard let newCount = presenter?.getPhotosCount() else {return}
//        guard let photos = presenter?.getPhotos() else {return}
//        if oldCount != newCount {
//            tableView.performBatchUpdates {
//                let indexPaths = (oldCount..<newCount).map{i in
//                    IndexPath(row: i, section: 0)}
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            } completion: { _ in }
//        }
        tableView.performBatchUpdates {
            let indexPaths = (from..<to).map{i in
                IndexPath(row: i, section: 0)}
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}


extension ImagesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)-> CGFloat{
//        let photo = imageListService.photos[indexPath.row]
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = photo.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = photo.size.height*scale + imageInsets.top + imageInsets.bottom
//        return cellHeight
        guard let cellHeight = presenter?.getCellHeight(indexPath: indexPath) else {return 0}
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let singleImageController  = SingleImageViewControllerCode()
//        guard let url = URL(string:photos[indexPath.row].largeImageURL) else {return }
//        singleImageController.url = url
//        singleImageController.modalPresentationStyle = .fullScreen
//        show(singleImageController, sender: self)
        guard let singleImageController = presenter?.getSingleImage(indexPath: indexPath) else {return }
//        show(singleImageController, sender: self)
        //TODO: Я ВОТ ТУТ ОСТАНОВИЛСЯ ПРОВЕРИТЬ ПРЕЗЕНТ ШОУ НЕ ОЧ РАБОТАЕТ ЕСЛИ ЧЕСТНО
        //TODO: ОСТАЛОСЬ ТЕСТЫ НАПИСАТЬ В ОСТАЛЬНОМ ВСЕ РАБОТАЕТ
        present(singleImageController, animated: true)

       }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == (imageListService.photos.count - 1) {
//            imageListService.fetchPhotosNextPage()
//        }
        presenter?.fetchNewPhotos(indexPath: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//      return imageListService.photos.count
        guard let count = presenter?.getPhotosCount() else {return 0}
        return count
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

extension ImagesListViewController: ImageListCellDelegate{
    func likeButtontapped(cell: ImagesListCell) {
        presenter?.likeTapped(cell)
//        cell.setButtonAvailability(false)
//        guard let indexPath = self.tableView.indexPath(for: cell) else{ return }
//        let photo = imageListService.photos[indexPath.row]
//        let isLiked = photo.isLiked
//        let id = photo.id
//        imageListService.likeButtonService(id: id, isLike: isLiked){ result in
//            DispatchQueue.main.async{
//                switch result{
//                case .success:
//                    cell.changeLikeImage(!isLiked)
//                case .failure(let error):
//                    print(error)
//                }
//                cell.setButtonAvailability(true)
//            }
//        }
    }
    
    
}


