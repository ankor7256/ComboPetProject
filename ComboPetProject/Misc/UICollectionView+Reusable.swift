//
//  UICollectionView+Reusable.swift
//  CustomCollectionExample
//
//  Created by Andrew K on 8/3/23.
//

import UIKit

extension UICollectionView {
    
    func registerCellFromNib(cell: UICollectionViewCell.Type) {
        register(cell.nib, forCellWithReuseIdentifier: cell.nibName)
    }
    func registerCell(cell: UICollectionViewCell.Type) {
        register(cell.self, forCellWithReuseIdentifier: cell.nibName)
    }
    
    func registerHeaderFromNib(cell: UICollectionViewCell.Type) {
        register(cell.nib,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: "headerView")
    }
    
    func dequeueHeader(indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: "headerView",
                                                for: indexPath)
    }
    
    func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.identifier) matching type \(cellType.self).")
        }
        return cell
    }
    
}

extension UICollectionViewCell: Reusable {
    open class var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView {
    class var nibName: String {
        return String(describing: self)
    }

    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self),
                                        owner: nil,
                                        options: nil)?
            .first as! T //swiftlint:disable:this force_cast
    }

    func connectNibUI() -> Any? {
        let nibView = Bundle.main.loadNibNamed(String(describing: type(of: self)),
                                               owner: nil,
                                               options: nil)?
            .first as! UIView //swiftlint:disable:this force_cast
        nibView.frame = frame
        self.addSubview(nibView)
        return nibView
    }
}
