import UIKit
import Combine

class LoginViewController: UIViewController {
    private var loginViewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.delegate = self
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 3
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            emailTextField.widthAnchor.constraint(equalToConstant: 350),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 350),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func bindViewModel() {
        loginViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    LoadingView.shared.show()
                } else {
                    LoadingView.shared.hide()
                }
            }
            .store(in: &cancellables)
        
        loginViewModel.$loginError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorModel in
                guard let self = self else { return }
                guard let errorModel = errorModel else { return }
                self.showAlert(alertErrorModel: errorModel)
            }
            .store(in: &cancellables)
        
        loginViewModel.$token
            .receive(on: DispatchQueue.main)
            .sink { [weak self] token in
                guard let self = self else { return }
                guard let token = token, !token.isEmpty else { return }
                self.presentUserListViewController(token)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        loginViewModel.validateTextFieldsData(email: emailTextField.text,
                                              password: passwordTextField.text)
        dismissKeyboard()
    }
}

extension LoginViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}

extension LoginViewController {
    //MARK: Navigation
    private func presentUserListViewController(_ token: String) {
        let userListViewController = UserListViewController()
        userListViewController.modalPresentationStyle = .overFullScreen
        userListViewController.userToken = token
        sceneDelegate?.window?.switchRootViewController(to: userListViewController)
    }
}
