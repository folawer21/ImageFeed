//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 08.03.2024.
//

import UIKit

final class TabBarController: UITabBarController{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tabBar.backgroundColor = UIColor(named:"YPBlack")
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListPresenter = ImageListPresenter()
//        guard let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let imageListViewController = ImagesListViewController()
        imageListViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named:"mainNoActive"), selectedImage: nil)
        imageListViewController.presenter = imageListPresenter
        imageListPresenter.view = imageListViewController
        
        
        let profilePresenter = ProfilePresenter()
        let profileViewController = ProfileViewController()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named:"profileNoActive"), selectedImage: nil)
        self.viewControllers = [imageListViewController, profileViewController]
    }
    
}
