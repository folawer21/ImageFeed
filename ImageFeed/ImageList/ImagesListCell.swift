//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 09.01.2024.
//

import UIKit
import Kingfisher
final class ImagesListCell: UITableViewCell{
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
}
