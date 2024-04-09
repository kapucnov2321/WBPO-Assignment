//
//  LoginViewModel.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 09/04/2024.
//

import Foundation

protocol LoginViewModelType {
    
}

class LoginViewModel: LoginViewModelType {
    
    private let coordinator: LoginCoordinatorType

    init(coordinator: LoginCoordinatorType) {
        self.coordinator = coordinator
    }
}
