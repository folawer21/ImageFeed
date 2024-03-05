//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 28.02.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    let imageView = UIImageView()
    let segueToAuthorization = "segueToAuthorization"
    let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileimageService = ProfileImageService.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSegue()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buildScreen()
    }
    private func buildScreen(){
        self.view.backgroundColor = UIColor(named: "YPBlack")
        imageView.image = UIImage(named: "SplashScreen")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController(){
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
   
    func showSegue(){
        if let token = tokenStorage.token {
            guard let token = tokenStorage.token else {return }
            fetchProfile(token)
//            switchToTabBarController()
        }
        else {
            self.performSegue(withIdentifier: segueToAuthorization, sender: self)
        }
    }
}


extension SplashViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToAuthorization {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(segueToAuthorization)")
                return
            }
            viewController.delegate = self
        }
        else{
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate{
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String){
        UIBlockingProgressHUD.show()
        dismiss(animated: true){ [weak self] in
            guard let self = self else {return }
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String){
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return }
            switch result {
            case .success(let token):
                self.tokenStorage.token = token
                self.fetchProfile(token)
                UIBlockingProgressHUD.dissmiss()
            case .failure:
                UIBlockingProgressHUD.dissmiss()
                self.showAlert()
                print(5555)
            }
        }
    }
   
    private func fetchProfile(_ token: String){
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token){ [weak self] result in
            UIBlockingProgressHUD.dissmiss()
            guard let self = self else {
                return}
            switch result {
            case .success(let profile):
                self.fetchPhoto(profile.username)
            case .failure(let error):
                print(44444)
                print(error)
            }
        }
    }
    private func fetchPhoto(_ username: String){
        UIBlockingProgressHUD.show()
        profileimageService.fetchProfileImageURL(username: username){ [weak self ] result in
            UIBlockingProgressHUD.dissmiss()
            guard let self = self else { return}
            switch result{
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                print(3333333)
                print(error)
            }
        }
    }
    private func showAlert(){
        let errorAlert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK",style: .default, handler: nil ))
        self.presentedViewController?.present(errorAlert,animated: true, completion: nil)
        
    }

}

