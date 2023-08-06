//
//  DemoViewController.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/3/23.
//

import UIKit

final class DemoViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var bigButton: UIButton!
    
    private let viewModel: DemoViewModelProtocol
    
    init(viewModel: DemoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        
        viewModel.updator = { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.reload()
        bigButton.addTarget(self, action: #selector(clearDB), for: .touchUpInside)
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = viewModel.title
        bigButton.titleLabel?.text = "Clear DataBase"
    }
    
    private func setupTableView() {
        tableView.registerFromNib(cell: UserTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel.reload()
    }

    @objc func clearDB(sender:UIButton) {
        viewModel.clearDB()
    }
}

extension DemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataStorage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let model = viewModel.dataStorage[indexPath.row]
        cell.configure(model: model)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension DemoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
