//
//  LoginViewModel.swift
//  SCMP Project
//
//  Created by Anson Wong on 21/1/2024.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    @Published var loginError: AlertErrorModel?
    @Published var token: String?
    
    func login(email: String, password: String) {
        isLoading = true
        loginError = nil
        
        let parameters = [
            "email": email,
            "password": password
        ]
        let urlRequest = URL(string: APIs.login)
        guard let urlRequest = urlRequest else { return }
        
        networkManager.post(url: urlRequest, parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    self.loginError = AlertErrorModel(title: "Login Error", msg: error.localizedDescription)
                }
                self.isLoading = false
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.handleLoginResponse(data)
            })
            .store(in: &cancellables)
    }
    
    private func handleLoginResponse(_ data: Data) {
        let errorString = try? JSONDecoder().decode(ErrorModel.self, from: data).error
        if let errorString = errorString, !errorString.isEmpty {
            loginError = AlertErrorModel(title: "Login Error", msg: errorString)
        } else {
            guard let tokenString = try? JSONDecoder().decode(TokenModel.self, from: data).token else { return }
            token = tokenString
        }
    }
    
    //MARK: - Validation
    func validateTextFieldsData(email: String?, password: String?) {
        guard let email = email,
              !email.isEmpty,
              let password = password,
              !password.isEmpty
        else {
            loginError = AlertErrorModel(title: "Information incomplete", 
                                         msg: "Please enter email or password.")
            return
        }
        
        // Perform email validation
        if !email.isValidEmail() {
            loginError = AlertErrorModel(title: "Invalid Email",
                                         msg: "Please enter a valid email address.")
            return
        }
        
        // Perform password validation
        if !password.isValidPassword() {
            loginError = AlertErrorModel(title: "Invalid Password",
                                         msg: "Password should be 6-10 characters long and contain only letters and numbers.")
            return
        }
        
        login(email: email, password: password)
    }
    
}
