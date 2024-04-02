//
//  WebViewPresenterSpy.swift
//  Image)FeedTests
//
//  Created by Александр  Сухинин on 02.04.2024.
//
import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol{
    var viewDidCallCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidCallCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String?{
        return nil
    }
    
}
