//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 09.01.2024.
//
import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject{
    func likeButtontapped(cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell{
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    @IBOutlet var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func likTapped(_ sender: Any) {
        delegate?.likeButtontapped(cell: self)
    }
    func setButtonAvailability(_ flag:Bool){
        likeButton.isEnabled = flag
    }
    func changeLikeImage(_ flag: Bool){
        if flag{
            self.likeButton.setImage(UIImage(named: "likeOn"), for: .normal)
        }else{
            self.likeButton.setImage(UIImage(named: "likeOff"), for: .normal)
        }
    }
    
    func configCell(photoUrl url: URL, isLiked: Bool,date: String){
        self.dateLabel.text = date
        if isLiked{
            self.likeButton.setImage(UIImage(named: "likeOn"), for: .normal)
        }else{
            self.likeButton.setImage(UIImage(named: "likeOff"), for: .normal)
        }
        imageCell.kf.setImage(with: url)
        imageCell.kf.indicatorType = .activity
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
}
