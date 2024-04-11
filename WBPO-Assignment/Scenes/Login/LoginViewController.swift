//
//  LoginViewController.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 09/04/2024.
//

import UIKit
import RxSwift
import RxCocoa
class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorTooltip: UILabel!
    @IBOutlet weak var loginBottomConstraint: NSLayoutConstraint!
    
    private let bag = DisposeBag()

    var viewModel: LoginViewModelType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindOutputs()
        bindInputs()
        setupKeyboardNotifications()
    }
    
    private func bindInputs() {
        guard let viewModel else { return }

        usernameTextField.rx.text
            .bind(to: viewModel.username)
            .disposed(by: bag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.password)
            .disposed(by: bag)
        
        loginButton.rx
            .tap
            .bind {
                viewModel.register()
            }
            .disposed(by: bag)

        viewModel.viewDidLoad()
    }
    
    private func bindOutputs() {
        viewModel?.isRegisterEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel?.errorMessage
            .subscribe(
                onNext: { [weak self] errorMessage in
                    guard let self else { return }
                
                    errorTooltip.text = errorMessage
                    errorTooltip.showView { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                            guard let self else { return }
        
                            errorTooltip.hideView()
                        }
                    }
                }
            )
            .disposed(by: bag)
    }
    
}

// MARK: - Private

extension LoginViewController {
    
    private func setupKeyboardNotifications() {
        let keyboardShownConstraintValue = NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                    return 40
                }
                
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height

                return keyboardHeight
            }
        let keyboardHiddenConstraintValue = NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                return 40
            }
        
        let isKeyboardShown = Observable.merge(keyboardShownConstraintValue, keyboardHiddenConstraintValue)
            .asDriver(onErrorJustReturn: 40)

        isKeyboardShown
            .drive { [weak self] value in
                guard let self else { return }

                loginBottomConstraint.constant = value
                view.layoutIfNeeded()
            }
            .disposed(by: bag)
    }
    
}
