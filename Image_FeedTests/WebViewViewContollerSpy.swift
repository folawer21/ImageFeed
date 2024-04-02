//
//  WebViewViewContollerSpy.swift
//  Image)FeedTests
//
//  Created by Александр  Сухинин on 02.04.2024.
//
import ImageFeed
import UIKit

final class WebViewViewContollerSpy:UIViewController & WebViewViewControllerProtocol{
    
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var didLoadCalled: Bool = false
    func load(request: URLRequest){
        didLoadCalled = true
    }
    func setProgressValue(_ newValue: Float) {
        
    }
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
