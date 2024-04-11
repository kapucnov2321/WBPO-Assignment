//
//  UserListViewController.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import UIKit

class UserListViewController: UIViewController {
    
    var viewModel: UserListViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindOutputs()
        bindInputs()
    }
    
    private func bindOutputs() {
        
        viewModel?.viewDidLoad()
    }
    
    private func bindInputs() {
        
    }
}
