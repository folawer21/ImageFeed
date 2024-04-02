//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.04.2024.
//

import Foundation

final class ProfilePresenter: ProfilePresenterProtocol{
    
    
    
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileService = ProfileService.shared
    private var logoutService = ProfileLogoutService.shared
    
    func setObserverForViewController(){
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification, object: nil, queue: .main){ [weak self] _ in
                guard let self = self else {return }
                self.didUpdateAvatar()
            }
        didUpdateAvatar()
    }
    
    func exitAccount() {
        logoutService.logout()
    }
    
    private func didUpdateAvatar(){
        guard let url = getProfileImage() else {return}
        view?.updateAvatar(with: url)
    }
    
    func getProfileImage() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {return nil}
        return url
    }
    
    func getProfile() -> Profile?{
        return profileService.profile
    }
    
}
