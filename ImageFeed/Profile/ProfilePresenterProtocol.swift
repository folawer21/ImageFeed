//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.04.2024.
//

import Foundation

public protocol ProfilePresenterProtocol: AnyObject{
    var view: ProfileViewControllerProtocol? {get set}
    
    func exitAccount()
    func setObserverForViewController()
    func getProfile() -> Profile?
    func getProfileImage() -> URL?
    func logoutButtonTapped()
}
