//
//  UserListViewController.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private let bag = DisposeBag()
    var viewModel: UserListViewModelType?

    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(
                            x: 0,
                            y: 0,
                            width: view.frame.size.width,
                            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTableView()
        bindOutputs()
        viewModel?.viewDidLoad()
    }
    
    private func bindOutputs() {
        viewModel?.showLoadingSpinner
            .subscribe(
                onNext: { [weak self] shown in
                    guard let self else { return }
        
                    tableView.tableFooterView = shown ? viewSpinner : UIView(frame: .zero)
                }
            )
            .disposed(by: bag)
    }

    private func bindTableView() {
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")

        viewModel?.userList
            .bind(to: tableView.rx
                .items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { (row,item,cell) in
                    cell.setupCell(user: item)
            }
            .disposed(by: bag)
        
        tableView.rx.contentOffset.subscribe { [weak self] offset in
            guard let self = self else { return }

            if offset.y + tableView.frame.size.height - 50 > tableView.contentSize.height {
                self.viewModel?.fetchUserList()
            }
        }
        .disposed(by: bag)
    }

}
