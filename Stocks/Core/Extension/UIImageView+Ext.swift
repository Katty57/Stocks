//
//  UIImageView+Ext.swift
//  Stocks
//
//  Created by  User on 10.06.2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(source: String?, placeholder: String?) {
        if let urlSource = source, let url = URL(string: urlSource),
            let imagePlaceholder = placeholder, let image = UIImage(systemName: imagePlaceholder) {
            kf.setImage(with: url, placeholder: image)
        }
    }
}
