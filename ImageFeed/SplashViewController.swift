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
            switchToTabBarController()
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
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
}

