//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 07.02.2024.
//

import Foundation
import UIKit


class SingleImageViewController: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
