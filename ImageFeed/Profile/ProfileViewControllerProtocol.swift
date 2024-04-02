//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.04.2024.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject{
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateAvatar(with url: URL)
    func setProfileData()
    
}
