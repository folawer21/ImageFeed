//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 09.01.2024.
//

protocol ImageListCellDelegate{
    func likeButtonService(id: String, isLike: Bool,_ completion: @escaping (Result<Void,Error>) -> Void)
}

import UIKit
import Kingfisher
final class ImagesListCell: UITableViewCell{
    static let reuseIdentifier = "ImagesListCell"
    private weak var delegate = ImageListService()
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func likTapped(_ sender: Any) {
        let isLiked = 
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
}
