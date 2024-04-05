//
//  ProfileControllerSpy.swift
//  Image)FeedTests
//
//  Created by Александр  Сухинин on 05.04.2024.
//

import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol{
    
    var isAlertShowed: Bool = false
    
    func showLogoutAlert(alert: UIAlertController) {
        isAlertShowed = true
    }
    
    var presenter: ProfilePresenterProtocol?
    
    func updateAvatar(with url: URL) {
        
    }
    
    func setProfileData() {
        
    }
}
