//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 09.01.2024.
//
import Kingfisher
import UIKit

protocol ImageListCellDelegate: AnyObject{
    func likeButtontapped(cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell{
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImageListCellDelegate?
    private lazy var  dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(named: "YPGray")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var likeButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "likeOn") ?? UIImage(), target: nil, action: #selector(didLikeTapped))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "LikeButton"
        return button
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "YPWhite")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
//    @IBOutlet var imageCell: UIImageView!
//    @IBOutlet weak var likeButton: UIButton!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBAction func likTapped(_ sender: Any) {
//        delegate?.likeButtontapped(cell: self)
//    }
    
    @objc private func didLikeTapped(){
        delegate?.likeButtontapped(cell: self)
    }
    func setButtonAvailability(_ flag:Bool){
        likeButton.isEnabled = flag
    }
    
    func addSubViews(){
        contentView.addSubview(imageCell)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
    }
    
    func applyConstraints(){
        NSLayoutConstraint.activate([
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageCell.trailingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor, constant: 8),
            imageCell.trailingAnchor.constraint(equalTo: likeButton.trailingAnchor),
            imageCell.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func changeLikeImage(_ flag: Bool){
        self.likeButton.tintColor = flag ? UIColor(named: "YPRed") : UIColor(named: "White50")
//        if flag{
//            self.likeButton.setImage(UIImage(named: "likeOn"), for: .normal)
//        }else{
//            self.likeButton.setImage(UIImage(named: "likeOff"), for: .normal)
//        }
    }

    func configCell(photoUrl url: URL, isLiked: Bool,date: Date?){
        contentView.backgroundColor = UIColor(named: "YPBlack")
        self.dateLabel.text = date != nil ? dateFormatter.string(from: date!) : ""
        self.likeButton.tintColor = isLiked ? UIColor(named: "YPRed") : UIColor(named: "White50")
//        self.likeButton.setImage(UIImage(named: isLiked ? "likeOn" : "likeOff"), for: .normal)
        let placeholderImage = UIImage(named: "Stub")
        imageCell.kf.setImage(with: url,placeholder: placeholderImage)
        imageCell.kf.indicatorType = .activity
        addSubViews()
        applyConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
}
