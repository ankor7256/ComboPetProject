//
//  DemoViewModel.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/3/23.
//

protocol DemoViewModelProtocol: AnyObject {
    var title: String { get }
    var dataStorage: [UserDTO] { get }
    var updator: () -> Void { get set }
    func loadMore()
    func reload()
    func clearDB()
}

final class DemoViewModel: DemoViewModelProtocol {
    var title: String = "API -> DB -> collection"
    var dataStorage: [UserDTO] = []
    var updator: () -> Void = {}
    private var totalPages: Int = 0
    private var currentPage: Int = 0
    private let apiManager: APIManager
    private let dbManager: UsersDBManagerProtocol

    init(
        apiManager: APIManager,
        dbManager: UsersDBManagerProtocol
    ) {
        self.apiManager = apiManager
        self.dbManager = dbManager
    }

    func loadMore() {
        currentPage += 1
        fetchUsers(page: currentPage)
    }

    func reload() {
        currentPage = 1
        fetchUsers(page: currentPage)
    }

    func clearDB() {
        dbManager.deleteUsers()
        dataStorage = dbManager.users()
        updator()
    }

    private func fetchUsers(page: Int) {
        apiManager.request(DemoTarget.fetchUsers(page: page)) { [weak self] (result: Result<UsersResponse, APIError>) in
                switch result {
                case .success(let response):
                    self?.storeUsers(response.data)
                case .failure(let error):
                    print("Something went wrong: \(error)")
                }
            }
    }

    private func storeUsers(_ users: [UserDataModel]) {
        dbManager.save(users: users)
        dataStorage = dbManager.users()
        updator()
    }
}
