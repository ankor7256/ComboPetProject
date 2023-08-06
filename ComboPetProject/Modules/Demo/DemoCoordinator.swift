//
//  DemoCoordinator.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import RxCocoa
import RxSwift

protocol DemoCoordinatorProtocol {
    func userDetails(_ user: UserDTO)
}

final class DemoCoordinator: DemoCoordinatorProtocol {
    
    weak var navigationController: UINavigationController?
    
    func start() -> UINavigationController {
        let apiManager: APIManager =
        FeatureTogglesState.isMockAPIEnabled ?
        MockAPIManager() :
        RXMoyaAPIManager()
        let dbManager = UsersRealmDBManager()
        let demoViewModel = DemoViewModel(apiManager: apiManager, dbManager: dbManager)
        let demoController = DemoViewController(viewModel: demoViewModel)
        let navigationController = UINavigationController()
        navigationController.setViewControllers([demoController], animated: true)
        self.navigationController = navigationController

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showFeatureToggles()
        }

        return navigationController
    }

    private func showFeatureToggles() {
        let vc = DebugFeatureTogglesVC(needRestart: false)
        let nc = UINavigationController(rootViewController: vc)
        navigationController?.present(nc, animated: true, completion: nil)
    }

    func userDetails(_ user: UserDTO) {}
}
