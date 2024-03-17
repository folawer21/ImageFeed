//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 16.03.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService{
    static let shared = ProfileLogoutService()
    
    private init(){}
    func logout(){
        cleanCookies()
        cleanToken()
        cleanImageList()
        cleanProfileData()
        cleanProfilePhoto()
        goToAuthScreen()
    }
    
    private func cleanCookies(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()){ records in
            records.forEach{record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    private func cleanToken(){
        let tokenStorage = OAuth2TokenStorage()
        tokenStorage.token = nil
        
    }
    private func cleanProfileData(){
        let profileService = ProfileService.shared
        profileService.setNilProfile()
    }
    
    private func cleanImageList(){
        let imageListService = ImageListService()
        imageListService.setPhotosNil()
    }
    private func cleanProfilePhoto(){
        let profileImageService = ProfileImageService.shared
        profileImageService.setNilUrl()
    }
    
    private func goToAuthScreen() {
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = SplashViewController()
        }
}
