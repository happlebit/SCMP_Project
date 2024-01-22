//
//  LoadingView.swift
//  SCMP Project
//
//  Created by Anson Wong on 21/1/2024.
//

import UIKit

class LoadingView {
    static let shared = LoadingView()
    
    private let loadingIndicator: UIActivityIndicatorView
    private let containerView: UIView
    
    private init() {
        containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = containerView.center
        
        containerView.addSubview(loadingIndicator)
    }
    
    func show() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
            
            let windows = windowScene.windows
            if let keyWindow = windows.first(where: { $0.isKeyWindow }) ?? windows.first {
                keyWindow.addSubview(self.containerView)
                self.loadingIndicator.startAnimating()
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
        }
    }
}
