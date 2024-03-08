//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 24.02.2024.
//

import ProgressHUD
import UIKit

protocol AuthViewControllerDelegate: AnyObject{
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
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
        configureScreen()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    private func configureScreen(){
        buildScreen()
        addSubViews()
        activateConstraints()
        configureBackButton()
    }
    private func buildScreen(){
        view.backgroundColor = UIColor(named: "YPBlack")
        authImageView.translatesAutoresizingMaskIntoConstraints = false
        authImageView.image = UIImage(named: "auth")
        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.backgroundColor = UIColor(named: "YPWhite")
        authButton.setTitle("Войти", for: .normal)
        authButton.setTitleColor(UIColor(named:"YPBlack"), for: .normal)
        authButton.layer.cornerRadius = 16
        authButton.layer.masksToBounds = true
        authButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    @objc func buttonTapped(_ sender: Any){
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        navigationController?.pushViewController(webViewController, animated: true)
    }
    private func addSubViews(){
        view.addSubview(authImageView)
        view.addSubview(authButton)
    }
    private func activateConstraints(){
        NSLayoutConstraint.activate([
            authImageView.widthAnchor.constraint(equalToConstant: 60),
            authImageView.heightAnchor.constraint(equalToConstant: 60),
            authImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            authImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            authButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            authButton.topAnchor.constraint(equalTo: authImageView.bottomAnchor, constant: 204)
        ])
    }
    private func configureBackButton(){
        navigationController?.navigationBar.backgroundColor = UIColor(named: "YPWhite")
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backButton")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButton")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
    }
}

extension AuthViewController: WebViewViewControllerDelegate{
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        self.delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
