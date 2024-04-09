//
//  LoginCoordinator.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 09/04/2024.
//

import UIKit

protocol LoginCoordinatorType {
    func start() -> UIViewController
}

class LoginCoordinator: LoginCoordinatorType {
    private weak var viewController: LoginViewController?
    private weak var navigationController: UINavigationController?

    func start() -> UIViewController {
        let vc = LoginViewController.instantiate()
        let navigationVC = UINavigationController(rootViewController: vc)
        
        vc.viewModel = LoginViewModel(coordinator: self)
        self.viewController = vc
        self.navigationController = navigationVC

        return navigationVC
    }
    
}
