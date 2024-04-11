//
//  UIView+Extension.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import UIKit

extension UIView {
    
    func hideView(completion: ((Bool) -> Void)? = nil) {
        setViewVisibility(isHidden: true, completion: completion)
    }
    
    func showView(completion: ((Bool) -> Void)? = nil) {
        setViewVisibility(isHidden: false, completion: completion)
    }
    
    func embed(view: UIView, topConstant: CGFloat = 0, bottomConstant: CGFloat = 0, leadingConstant: CGFloat = 0, trailingConstant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant)
        ])
    }
    
    private func setViewVisibility(isHidden: Bool, completion: ((Bool) -> Void)?) {
        UIView.transition(
            with: self,
            duration: 0.3,
            animations: { [weak self] in
                self?.isHidden = isHidden
            },
            completion: completion
        )
    }
}
