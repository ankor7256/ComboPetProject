//
//  UITableView+Reusable.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/3/23.
//

import UIKit

extension UITableView {

    func register<T: Reusable>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.identifier)
    }

    func register<T: Reusable>(cellType: T.Type, bundle: Bundle?) {
        let nib = UINib(nibName: cellType.identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: cellType.identifier)
    }

    func registerFromNib(cell: UITableViewCell.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.nibName)
    }

    func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self).")
        }
        return cell
    }

    func register<T: Reusable>(viewType: T.Type) {
        register(viewType.self, forHeaderFooterViewReuseIdentifier: viewType.identifier)
    }

    func dequeueReusableHeaderFooterView<T: Reusable>() -> T {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(T.identifier) matching type \(T.self).")
        }
        return headerFooter
    }
}

extension UITableViewCell: Reusable {
    open class var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}

extension UITableViewHeaderFooterView: Reusable { }
