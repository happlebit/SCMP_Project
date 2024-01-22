//
//  Constants.swift
//  SCMP Project
//
//  Created by Anson Wong on 21/1/2024.
//

import Foundation
import UIKit

let basicAPIHost = "https://reqres.in/api/"

var sceneDelegate: SceneDelegate? {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let delegate = windowScene.delegate as? SceneDelegate else { return nil }
    return delegate
    }

// MARK: - Methods
public extension UIWindow {
    /// - Parameters:
    ///   - viewController: new view controller.
    ///   - animated: set to true to animate view controller change (default is true).
    ///   - duration: animation duration in seconds (default is 0.5).
    ///   - options: animation options (default is .transitionFlipFromRight).
    ///   - completion: optional completion handler called after view controller is changed.
    func switchRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        _ completion: (() -> Void)? = nil) {
            
            guard animated else {
                rootViewController = viewController
                completion?()
                return
            }
            
            UIView.transition(with: self, duration: duration, options: options, animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.rootViewController = viewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                completion?()
            })
        }
    
}
