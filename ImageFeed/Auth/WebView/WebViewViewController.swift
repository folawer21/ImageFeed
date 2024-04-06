//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 24.02.2024.
//


import UIKit
import WebKit
public protocol WebViewViewControllerProtocol:AnyObject{
    var presenter: WebViewPresenterProtocol? {get set}
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    weak var delegate : WebViewViewControllerDelegate?
    private var webView = WKWebView()
    private var progressBar = UIProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        buildScreen()
        setNeedsStatusBarAppearanceUpdate()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress, 
             changeHandler: {[weak self]_,_ in
                 guard let self = self else {return }
                 self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
        
    private func buildScreen() {
        webView.backgroundColor = UIColor(named: "YPWhite")
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.accessibilityIdentifier = "UnsplashWebView"
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: super.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: super.view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: super.view.bottomAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        progressBar.progressTintColor = UIColor(named: "YPBlack")
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

    }
    
    func load(request: URLRequest){
        webView.load(request)
        print(21312)
    }
    
//    private func loadAuthView(){
//        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else{
//            print("Ошибка разворачивания URLComponents ")
//            return
//        }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope)
//        ]
//        guard let url = urlComponents.url else {
//            print("Ошибка разворачивания URL")
//            return }
//        let request  = URLRequest(url: url)
//        webView.load(request)
//    }
//
    func setProgressValue(_ newValue: Float){
        progressBar.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool){
        progressBar.isHidden = isHidden
    }
}

extension WebViewViewController: WKNavigationDelegate{
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url{
            return presenter?.code(from: url)
        }
        return nil
//        if
//            let url  = navigationAction.request.url,
//            let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: {$0.name == "code"})
//        {
//            return codeItem.value
//        }
//        else{
//            return nil
//        }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction){
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
            
        }else {
            decisionHandler(.allow)
        }
    }
}
