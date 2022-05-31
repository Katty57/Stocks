//
//  StockTableViewCell.swift
//  Stocks
//
//  Created by  User on 25.05.2022.
//

import UIKit

final class StockTableViewCell: UITableViewCell {
    
    private lazy var iconView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.image = UIImage(named: "YNDX")
        return image
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "YNDX"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpSubviews(array: [iconView, symbolLabel])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews (array: [UIView]) {
        array.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            symbolLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
