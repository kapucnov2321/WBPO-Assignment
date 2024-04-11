//
//  UIViewController+Extension.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 09/04/2024.
//

import UIKit

extension UIViewController {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)

        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Storyboard Error: Class not set/Initial VC Not set")
        }
    
        return vc
    }
    
    func showLoading() {
        let loadingView = LoadingView()
        loadingView.tag = 10
        loadingView.alpha = 0

        DispatchQueue.main.async {
            UIView.transition(
                with: self.view,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: {
                    self.view.addSubview(loadingView)
                    loadingView.alpha = 1
                },
                completion: nil
            )
            
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate(
                [
                    loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                    loadingView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                    loadingView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
                ]
            )
        }
        
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            guard let loadingView = self.view.viewWithTag(10) as? LoadingView else { return }

            UIView.transition(
                with: loadingView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    loadingView.alpha = 0
                },
                completion: { _ in
                    loadingView.removeFromSuperview()
                }
            )
        }
    }
}
