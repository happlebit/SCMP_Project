//
//  UserListViewModel.swift
//  SCMP Project
//
//  Created by Anson Wong on 22/1/2024.
//

import Foundation
import Combine

class UserListViewModel: ObservableObject {
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    @Published var error: AlertErrorModel?
    @Published var hasMorePages: Bool = false
    
    @Published var userListModel: UserListModel?
    
    func getUserListModel(currentPage: Int) {
        isLoading = true
        error = nil
        
        let urlRequest = URL(string: APIs.getUserList + "\(currentPage)")
        guard let urlRequest = urlRequest else { return }
        
        networkManager.getData(from: urlRequest)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    self.error = AlertErrorModel(msg: error.localizedDescription)
                }
                self.isLoading = false
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.handleUserListResponse(data, currentPage: currentPage)
            })
            .store(in: &cancellables)
    }
    
    private func handleUserListResponse(_ data: Data, currentPage: Int) {
        let errorString = try? JSONDecoder().decode(ErrorModel.self, from: data).error
        if let errorString = errorString, !errorString.isEmpty {
            error = AlertErrorModel(msg: errorString)
        } else {
            guard let userListModel = try? JSONDecoder().decode(UserListModel.self, from: data) else { return }
            self.userListModel = userListModel
            self.hasMorePages = currentPage < userListModel.totalPages ?? 0 
        }
    }
}
