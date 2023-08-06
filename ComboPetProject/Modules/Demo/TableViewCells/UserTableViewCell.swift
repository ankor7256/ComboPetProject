//
//  UserTableViewCell.swift
//  AlamofireExample
//
//  Created by Andrew K on 8/3/23.
//

import Kingfisher
import UIKit
import SwiftUI

final class UserTableViewCell: UITableViewCell {

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    
    private var model: UserDTO?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        emailLabel.text = nil
        avatarImageView.image = nil
    }
    
    func configure(model: UserDTO) {
        self.model = model
        nameLabel.text = model.fullName
        emailLabel.text = model.email
        avatarImageView.kf.setImage(with: model.avatarUrl)
    }
    
    private func setupUI() {
        selectionStyle = .none
        avatarImageView.layer.cornerRadius = 8
    }
    
}
