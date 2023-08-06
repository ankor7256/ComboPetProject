//
//  DebugFeatureTogglesVC.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import UIKit
import SwiftUI
import DiffableDataSources

final class DebugFeatureTogglesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        #if !RELEASE
        guard needRestart && valuesChanged else { return }
        // home button pressed programmatically - to thorw app to background
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        // terminaing app in background
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            exit(EXIT_SUCCESS)
        })
        #endif
    }

    init(needRestart: Bool = false) {
        self.needRestart = needRestart
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var valuesChanged: Bool = false
    private let needRestart: Bool
    private let table: UITableView = UITableView()
    private var dataSource: TableViewDiffableDataSource<FeatureSection, FeatureValue>?

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviewsWithoutAutoresizing([table])
        view.embed(table, insets: .init(top: 20, left: 0, bottom: 0, right: 0))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
    }
    private func setupTable() {
        table.rowHeight = 65
        table.separatorInset = .zero
        table.tableFooterView = UIView(frame: .zero)
        table.register(FeatureCell.self, forCellReuseIdentifier: "cell")
        dataSource = TableViewDiffableDataSource(tableView: table, cellProvider: {[weak self] (table, index, item) -> UITableViewCell? in
            let cell = table.dequeueReusableCell(withIdentifier: "cell")
            if let fcell = cell as? FeatureCell {
                fcell.fill(feature: item.feature, value: item.value)
                fcell.delegate = self
                fcell.selectionStyle = .none
            }
            return cell
        })
        table.delegate = self
    }

    private func update() {
        let features = FeatureToggles.allCases
        let service = FeatureTogglesFactory.sharedService
        let items = features.map { feature -> FeatureValue in
            let value = service.getValue(for: feature)
            return FeatureValue(feature: feature, value: value)
        }
        var snapshot = DiffableDataSourceSnapshot<FeatureSection, FeatureValue>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    @objc private func doneAction() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension DebugFeatureTogglesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard #available(iOS 13.0, *) else { return }
        guard let feature = dataSource?.snapshot().itemIdentifiers.safeItem(at: indexPath.item) else {
            assertionFailure()
            return
        }
        let service = FeatureTogglesFactory.sharedService
        let vc = UIHostingController(rootView: FTDetailsView(feature: feature.feature, service: service))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DebugFeatureTogglesVC: FeatureCellDelegate {
    func valueChanged(feature: FeatureToggles, value: Bool) {
        let service = FeatureTogglesFactory.sharedService
        service.overrideLocal(value: value, for: feature)
        update()
        valuesChanged = true
    }

    func clear(feature: FeatureToggles) {
        let service = FeatureTogglesFactory.sharedService
        service.overrideLocal(value: nil, for: feature)
        update()
        valuesChanged = true
    }
}

private enum FeatureSection {
    case main
}

private struct FeatureValue: Hashable {
    let value: FeatureToggleValue
    let feature: FeatureToggles

    static func == (lhs: FeatureValue, rhs: FeatureValue) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(feature)
        hasher.combine(value.isEnabled)
    }

    init(feature: FeatureToggles, value: FeatureToggleValue) {
        self.feature = feature
        self.value = value
    }
}

private protocol FeatureCellDelegate: AnyObject {
    func valueChanged(feature: FeatureToggles, value: Bool)
    func clear(feature: FeatureToggles)
}

private final class FeatureCell: UITableViewCell {
    weak var delegate: FeatureCellDelegate?

    func fill(feature: FeatureToggles, value: FeatureToggleValue) {
        titleLabel.text = feature.rawValue
        statusLabel.isHidden = true
        toggle.setOn(value.isEnabled, animated: false)
        self.feature = feature
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16, weight: .regular)
        v.textColor = .black
        v.lineBreakMode = .byCharWrapping
        v.numberOfLines = 2
        return v
    }()
    private let statusLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 12, weight: .regular)
        v.textColor = .lightGray
        v.text = "Overridden localy"
        return v
    }()
    private let toggle: UISwitch = {
        let v = UISwitch()
        return v
    }()
    private let infoImage: UIImageView = {
        let v = UIImageView()
        v.tintColor = .gray
        if #available(iOS 13.0, *) {
            v.image = UIImage(systemName: "chevron.right")
        }
        return v
    }()
    private var feature: FeatureToggles?

    private func setupUI() {
        if #available(iOS 14, *) {
            // fix interaction with UISwitch
            contentView.isUserInteractionEnabled = false
        }

        let views = [titleLabel, statusLabel, toggle, infoImage]
        addSubviewsWithoutAutoresizing(views)
        NSLayoutConstraint.activate([
            infoImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            infoImage.centerYAnchor.constraint(equalTo: centerYAnchor),

            toggle.rightAnchor.constraint(equalTo: infoImage.leftAnchor, constant: -8),
            toggle.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: toggle.leftAnchor, constant: -8),

            statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            statusLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            statusLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            statusLabel.rightAnchor.constraint(lessThanOrEqualTo: toggle.leftAnchor, constant: -8)

        ])
        toggle.addTarget(self, action: #selector(onToggleChanged(_:)), for: .valueChanged)
    }

    @objc private func onToggleChanged(_ sender: UISwitch) {
        guard let feature = self.feature else { return }
        let value = sender.isOn
        delegate?.valueChanged(feature: feature, value: value)
    }
}
