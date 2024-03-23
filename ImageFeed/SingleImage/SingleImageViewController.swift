//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 07.02.2024.
//

//import Foundation
//import UIKit
//
//
//final class SingleImageViewController: UIViewController{
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var imageView: UIImageView!
//    @IBAction func didBackButtonTap(_ sender: Any) {
//        dismiss(animated: true,completion: nil)
//    }
//    
//    @IBAction func didTapShareButton(_ sender: Any) {
//        guard let image = image else {return }
//        let share = UIActivityViewController(activityItems:[image] , applicationActivities: nil)
//        present(share,animated: true, completion: nil)
//    }
//    
//    var image: UIImage? {
//        didSet {
//            guard isViewLoaded else { return }
//            imageView.image = image
//            if let image = image{rescaleAndCenterImageInScrollView(image: image)}
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        scrollView.minimumZoomScale = 0.1
//        scrollView.maximumZoomScale = 1.25
//        imageView.image = image
//        if let image = image{rescaleAndCenterImageInScrollView(image: image)}
//    }
//    private func rescaleAndCenterImageInScrollView(image: UIImage){
//        let minimumZoomScale = scrollView.minimumZoomScale
//        let maximumZoomScale = scrollView.maximumZoomScale
//        view.layoutIfNeeded()
//        let visibleRectSize = scrollView.bounds.size
//        let imageSize = image.size
//        let hscale = visibleRectSize.height / imageSize.height
//        let wscale = visibleRectSize.width / imageSize.width
//        let scale = min(maximumZoomScale,max(minimumZoomScale,min(hscale,wscale)))
//        scrollView.setZoomScale(scale, animated: false)
//        scrollView.layoutIfNeeded()
//        let newContentSize = scrollView.contentSize
//        let x = (newContentSize.width - visibleRectSize.width)/2
//        let y = (newContentSize.height - visibleRectSize.height)/2
//        scrollView.setContentOffset(CGPoint(x:x,y:y), animated: false)
//        
//    }
//}
//
//extension SingleImageViewController: UIScrollViewDelegate{
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        imageView
//    }
//}
