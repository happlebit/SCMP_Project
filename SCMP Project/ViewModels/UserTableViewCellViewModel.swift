//
//  UserTableViewCellViewModel.swift
//  SCMP Project
//
//  Created by Anson Wong on 22/1/2024.
//

import Foundation
import UIKit
import Combine

class UserTableViewCellViewModel {
    let email: AnyPublisher<String?, Never>
    let firstName: AnyPublisher<String?, Never>
    let lastName: AnyPublisher<String?, Never>
    let iconImage: AnyPublisher<UIImage?, Never>
    
    init(user: UserModel) {
        email = Just(user.email)
            .eraseToAnyPublisher()
        
        firstName = Just(user.firstName)
            .eraseToAnyPublisher()
        
        lastName = Just(user.lastName)
            .eraseToAnyPublisher()
        
        if let iconUrl = user.iconImageUrl, let url = URL(string: iconUrl) {
            iconImage = URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { data, _ -> UIImage in
                    guard let image = UIImage(data: data) else {
                        print("Image Loading ERROR")
                        throw NSError()
                    }
                    return image
                }
                .replaceError(with: UIImage())
                .eraseToAnyPublisher()
        } else {
            iconImage = Just(UIImage())
                .eraseToAnyPublisher()
        }
    }
}
