//
//  SingleImageViewControllerCode.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 14.03.2024.
//

import UIKit
import Kingfisher


final class SingleImageViewControllerCode: UIViewController{
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var imageView: UIImageView = UIImageView()
    private lazy var shareButton: UIButton = UIButton()
    private lazy var backButton: UIButton = UIButton()
    var url : URL?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildScreen()
        addSubViews()
        activateConstraits()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        if let image = imageView.image { rescaleAndCenterImageInScrollView(image: image)}
    }
    
    private func buildScreen(){
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url){ [weak self] result in
            UIBlockingProgressHUD.dissmiss()
            guard let self = self else {return}
            switch result {
            case .success(let imageResult):
                rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
        imageView.kf.indicatorType = .activity
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(named:"YPBlack")
       
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(named: "backward"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(UIImage(named: "shareButton"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    @objc func backButtonTapped(_ sender: Any){
        dismiss(animated:true,completion: nil)
    }
    @objc func shareButtonTapped(_ sender: Any){
        guard let image = imageView.image else {return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share,animated: true,completion: nil)
    }
    
    
    private func addSubViews(){
        view.addSubview(scrollView)
        view.addSubview(backButton)
        scrollView.addSubview(imageView)
        view.addSubview(shareButton)
    }
    
    private func activateConstraits(){
        NSLayoutConstraint.activate([
            //TODO: Maybe change view to scrollView
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            shareButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: 51),
            shareButton.widthAnchor.constraint(equalToConstant: 51),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func showError(){
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Не надо", style: .default){ _ in
            alert.dismiss(animated: true)
        }
        let yesAction = UIAlertAction(title: "Повторить", style: .default){ [weak self] _ in
            guard let self = self else {return }
            self.imageView.kf.setImage(with: url )
        }
        alert.addAction(noAction)
        alert.addAction(yesAction)
        show(alert, sender: self)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage){
        let minimumZoomScale = scrollView.minimumZoomScale
        let maximumZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hscale = visibleRectSize.height / imageSize.height
        let wscale = visibleRectSize.width / imageSize.width
        let scale = min(maximumZoomScale,max(minimumZoomScale,min(hscale,wscale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width)/2
        let y = (newContentSize.height - visibleRectSize.height)/2
        scrollView.setContentOffset(CGPoint(x:x,y:y), animated: false)
        
    }
}

extension SingleImageViewControllerCode: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

