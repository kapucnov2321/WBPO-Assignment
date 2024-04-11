//
//  UserListCoordinator.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import UIKit

protocol UserListCoordinatorType: BaseCoordinator {
    func start(navigationController: UINavigationController?)
}

class UserListCoordinator: UserListCoordinatorType {

    weak var viewController: UIViewController?
    weak var navigationController: UINavigationController?
    
    func start(navigationController: UINavigationController?) {
        let vc = UserListViewController.instantiate()

        vc.viewModel = UserListViewModel(coordinator: self)

        self.navigationController = navigationController
        self.viewController = vc
        
        navigationController?.setViewControllers([vc], animated: true)
    }
    
}
