//
//  UserListViewModel.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import Foundation

class UserListViewModelType {
    func viewDidLoad() {}
}

class UserListViewModel: UserListViewModelType {
    private let coordinator: UserListCoordinatorType
    
    init(coordinator: UserListCoordinatorType) {
        self.coordinator = coordinator
    }

    override func viewDidLoad() {
        
    }
}
