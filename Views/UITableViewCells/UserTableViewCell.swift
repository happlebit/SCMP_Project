//
//  UserTableViewCell.swift
//  SCMP Project
//
//  Created by Anson Wong on 21/1/2024.
//

import Foundation
import UIKit
import Combine

class UserTableViewCell: UITableViewCell {
    static let cellID = "UserTableViewCell"
    
    // MARK: - Image Loading Task
    private var imageLoadingTask: URLSessionDataTask?
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    let iconImageView = UIImageView()
    let emailLabel = UILabel()
    let firstNameLabel = UILabel()
    let lastNameLabel = UILabel()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 20
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        emailLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailLabel)
        
        firstNameLabel.font = UIFont.systemFont(ofSize: 14)
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(firstNameLabel)
        
        lastNameLabel.font = UIFont.systemFont(ofSize: 14)
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lastNameLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            emailLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            firstNameLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            firstNameLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            firstNameLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            
            lastNameLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 4),
            lastNameLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
        ])
    }
    
    
    private func cancelImageLoading() {
        imageLoadingTask?.cancel()
        imageLoadingTask = nil
    }
    
    // MARK: - Configuration
    func configure(with userModel: UserModel) {
        let viewModel = UserTableViewCellViewModel(user: userModel)
        viewModel.email
            .assign(to: \.text, on: emailLabel)
            .store(in: &cancellables)
        
        viewModel.firstName
            .assign(to: \.text, on: firstNameLabel)
            .store(in: &cancellables)
        
        viewModel.lastName
            .assign(to: \.text, on: lastNameLabel)
            .store(in: &cancellables)
        
        //Subscribe on Main thread because the loader is async
        viewModel.iconImage
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: iconImageView)
            .store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel any ongoing Combine subscriptions
        cancellables.removeAll()
        
        // Cancel any ongoing image loading task
        cancelImageLoading()
        
        // Reset the image view's image
        iconImageView.image = nil
    }
}
