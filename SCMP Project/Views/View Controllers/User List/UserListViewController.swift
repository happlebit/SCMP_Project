//
//  UserListViewController.swift
//  SCMP Project
//
//  Created by Anson Wong on 21/1/2024.
//

import Foundation
import UIKit
import Combine

class UserListViewController: UIViewController {
    var userToken: String?
    
    private var userListViewModel = UserListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var tokenLabel = UILabel()
    private let tableView = UITableView()
    private var loadMoreButton = UIButton()
    private var currentPage = 1
    private var userListData: [UserModel] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLoadMoreButton()
        bindViewModel()
        loadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        tokenLabel.text = userToken
        tokenLabel.textColor = .white
        tokenLabel.textAlignment = .center
        tokenLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tokenLabel)
        
        NSLayoutConstraint.activate([
            tokenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tokenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tokenLabel.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLoadMoreButton() {
        loadMoreButton = UIButton(type: .system)
        loadMoreButton.setTitle("Load More", for: .normal)
        loadMoreButton.addTarget(self, action: #selector(loadMoreButtonTapped), for: .touchUpInside)
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        footerView.addSubview(loadMoreButton)
        
        loadMoreButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        loadMoreButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        tableView.tableFooterView = footerView
        
        updateLoadMoreButtonVisibility()
    }
    
    private func bindViewModel() {
        userListViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    LoadingView.shared.show()
                } else {
                    LoadingView.shared.hide()
                }
            }
            .store(in: &cancellables)
        
        userListViewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorModel in
                guard let self = self else { return }
                guard let errorModel = errorModel else { return }
                self.showAlert(alertErrorModel: errorModel)
            }
            .store(in: &cancellables)
        
        userListViewModel.$userListModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userListModel in
                guard let self = self else { return }
                guard let userListModelData = userListModel?.data, !userListModelData.isEmpty else { return }
                self.userListData.append(contentsOf: userListModelData)
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        userListViewModel.$hasMorePages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasMorePages in
                guard let self = self else { return }
                self.updateLoadMoreButtonVisibility()
            }.store(in: &cancellables)

    }
    
    // MARK: - Load More
    private func updateLoadMoreButtonVisibility() {
        if userListViewModel.hasMorePages {
            tableView.tableFooterView?.isHidden = false
        } else {
            tableView.tableFooterView?.isHidden = true
        }
    }
    
    @objc private func loadMoreButtonTapped() {
        guard !userListViewModel.isLoading else { return }
        currentPage += 1
        loadData()
    }
    
    // MARK: - Data Loading
    func loadData() {
        userListViewModel.getUserListModel(currentPage: currentPage)
    }
}

extension UserListViewController: UITableViewDataSource {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellID,
                                                 for: indexPath) as! UserTableViewCell
        
        guard let user = userListData[safe: indexPath.row] else { return UITableViewCell() }
        cell.configure(with: user)
        return cell
    }
}

extension UserListViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
