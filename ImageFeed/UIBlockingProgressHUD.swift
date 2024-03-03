//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.03.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD{
    private static var window: UIWindow?{
        return UIApplication.shared.windows.first
    }
    
    static func show(){
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    static func dissmiss(){
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
