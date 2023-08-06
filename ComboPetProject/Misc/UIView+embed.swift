//
//  UIView+embed.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import UIKit

public extension UIView {
    func embedingConstraints(for view: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return [
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
        ]
    }

    func centeringConstraints(for view: UIView) -> [NSLayoutConstraint] {
        return [
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
    }

    func sizingConstraints(_ size: CGSize) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
    }

    func embed(_ view: UIView, insets: UIEdgeInsets = .zero) {
        let constraints = embedingConstraints(for: view, insets: insets)
        NSLayoutConstraint.activate(constraints)
    }

    func center(_ view: UIView) {
        let constraints = centeringConstraints(for: view)
        NSLayoutConstraint.activate(constraints)
    }

    func size(_ size: CGSize) {
        let constraints = sizingConstraints(size)
        NSLayoutConstraint.activate(constraints)
    }
}

