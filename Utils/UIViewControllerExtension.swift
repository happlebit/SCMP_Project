//
//  UIViewControllerExtension.swift
//  SCMP Project
//
//  Created by Anson Wong on 22/1/2024.
//

import Foundation
import UIKit

extension UIViewController {
    //MARK: Alert
    func showAlert(alertErrorModel: AlertErrorModel) {
        guard let msg = alertErrorModel.msg, !msg.isEmpty else { return }
        let title = alertErrorModel.title ?? "ERROR"
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Dismissal
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
