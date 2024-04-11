//
//  LoginViewModel.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 09/04/2024.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModelType {

    //INPUT
    let username = BehaviorSubject<String?>(value: "")
    let password = BehaviorSubject<String?>(value: "")
    
    //OUTPUT
    let isRegisterEnabled = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()

    func viewDidLoad() {}
    func register() {}
}

class LoginViewModel: LoginViewModelType {
    
    private let coordinator: LoginCoordinatorType
    private let bag = DisposeBag()

    init(coordinator: LoginCoordinatorType) {
        self.coordinator = coordinator
    }
    
    override func viewDidLoad() {
        bindRegisterButtonEnable()
    }
    
    override func register() {
        guard let email = try? username.value(), let password = try? password.value() else {
            return
        }

        coordinator.showLoader()
        ApiClient.register(credentials: RegisterRequestModel(email: email, password: password))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] result in
                    self?.coordinator.hideLoader()
                    self?.coordinator.showUserList()
                },
                onError: { [weak self] error in
                    self?.coordinator.hideLoader()
                    self?.errorMessage.onNext(error.localizedDescription)
                }
            )
            .disposed(by: bag)
    }
    
}

// MARK: - Private

extension LoginViewModel {

    private func bindRegisterButtonEnable() {
        Observable
            .combineLatest(username.map { $0?.count ?? 0 >= 5 }, password.map { $0?.count ?? 0 >= 5 })
            .map { $0 && $1 }
            .subscribe { self.isRegisterEnabled.onNext($0) }
            .disposed(by: bag)
    }

}
