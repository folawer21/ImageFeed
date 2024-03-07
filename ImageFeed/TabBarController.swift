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
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        imageListViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named:"mainNoActive"), selectedImage: nil)
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named:"profileNoActive"), selectedImage: nil)
        self.viewControllers = [imageListViewController, profileViewController]
    }
    
    
    
}
