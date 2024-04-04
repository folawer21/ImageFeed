//
//  ImageListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.04.2024.
//

import UIKit

protocol ImageListViewControllerProtocol: AnyObject{
    var presenter: ImageListPresenterProtocol? {get set}
    func updateTableViewAnimated()
    func getTableView() -> UITableView
}
