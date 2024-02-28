//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 28.02.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    let segueToAuthorization = "segueToAuthorization"
    let segueToFeed = "segueToFeed"
    
    let tokenStorage = OAuth2TokenStorage()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSegue()
    }
    
    
   
    func showSegue(){
        if let token = tokenStorage.token {
            
            self.performSegue(withIdentifier: segueToFeed, sender: self)
        }
        else {
            

            self.performSegue(withIdentifier: segueToAuthorization, sender: self)
        }
    }
    
    
    
    
    
}
