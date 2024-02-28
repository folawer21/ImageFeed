//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 24.02.2024.
//


import UIKit

protocol AuthViewControllerDelegate: AnyObject{
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    private lazy var authImageView = UIImageView()
    private lazy var authButton = UIButton()
    private let tokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    private let ShowWebViewSegueIdentifier = "showWebView"
    override func viewDidLoad() {
        super.viewDidLoad()
        buildScreen()
        configureBackButton()
    }
    
    func buildScreen(){
        view.backgroundColor = UIColor(named: "YPBlack")
        authImageView.translatesAutoresizingMaskIntoConstraints = false
        authImageView.image = UIImage(named: "auth")
        view.addSubview(authImageView)
        NSLayoutConstraint.activate([
            authImageView.widthAnchor.constraint(equalToConstant: 60),
            authImageView.heightAnchor.constraint(equalToConstant: 60),
            authImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            authImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.backgroundColor = UIColor(named: "YPWhite")
        authButton.setTitle("Войти", for: .normal)
        authButton.setTitleColor(UIColor(named:"YPBlack"), for: .normal)
        authButton.layer.cornerRadius = 16
        authButton.layer.masksToBounds = true
        authButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(authButton)
        NSLayoutConstraint.activate([
            authButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            authButton.topAnchor.constraint(equalTo: authImageView.bottomAnchor, constant: 204)
        ])
        
    }
    @objc func buttonTapped(_ sender: Any){
        self.performSegue(withIdentifier: ShowWebViewSegueIdentifier, sender: self)
    }
    
    private func configureBackButton(){
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButton")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButton")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

extension AuthViewController: WebViewViewControllerDelegate{
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        oauth2Service.fetchOAuthToken(code: code){ result in
            switch result{
            case .success(let token):
                self.tokenStorage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
