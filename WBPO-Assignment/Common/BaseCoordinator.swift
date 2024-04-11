//
//  BaseCoordinator.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import UIKit

protocol BaseCoordinator {
    var viewController: UIViewController? { get set }
    var navigationController: UINavigationController? { get set }
}

extension BaseCoordinator {
    func showLoader() {
        navigationController?.showLoading()
    }
    
    func hideLoader() {
        navigationController?.hideLoader()
    }
}
