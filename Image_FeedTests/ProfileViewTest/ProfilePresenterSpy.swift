//
//  ProfilePresenterSpy.swift
//  Image)FeedTests
//
//  Created by Александр  Сухинин on 05.04.2024.
//


import Foundation
import ImageFeed
final class ProfilePresenterSpy: ProfilePresenterProtocol{
    func logoutButtonTapped() {
    }
    
    var observerDidSet: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func setObserverForViewController(){
        observerDidSet = true
    }
    
    func exitAccount() {
    }
    
    func getProfile() -> Profile? {
        return nil
    }
    
    func getProfileImage() -> URL? {
        return nil
    }
    
    
}
