//
//  StockTableViewCell.swift
//  Stocks
//
//  Created by  User on 25.05.2022.
//

import UIKit

final class StockTableViewCell: UITableViewCell {
    
    static var cellIndex = 0
    
    private lazy var cellView: UIView = {
        let view = UIView()
        [iconView, infoView, digitView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func getIndex (index: Int) {
        if index % 2 == 0 {
            cellView.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0)
        } else {
            cellView.backgroundColor = .white
        }
        cellView.layer.cornerRadius = 12
        cellView.clipsToBounds = true
    }
    
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
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "star_off"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        [symbolLabel, companyLabel, favouriteButton].forEach { view.addSubview($0) }
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changePriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.textColor = UIColor(red: 0.14, green: 0.7, blue: 0.36, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var digitView: UIView = {
        let view = UIView()
        view.addSubview(priceLabel)
        view.addSubview(changePriceLabel)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure (with model: StockModelProtocol) {
        symbolLabel.text = model.symbol
        companyLabel.text = model.name
        priceLabel.text = model.price
        changePriceLabel.text = model.change
        changePriceLabel.textColor = model.changeColor
    }
    
    private func setUpSubviews () {
        contentView.addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            iconView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
            iconView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            iconView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8),
            iconView.heightAnchor.constraint(equalToConstant: 52),
            iconView.widthAnchor.constraint(equalToConstant: 52),
            
            infoView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            infoView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 14),
            infoView.widthAnchor.constraint(equalToConstant: 170),
            infoView.heightAnchor.constraint(equalToConstant: 40),
            
            symbolLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            
            companyLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            companyLabel.topAnchor.constraint(equalTo: favouriteButton.bottomAnchor, constant: 5),
            
            favouriteButton.topAnchor.constraint(equalTo: symbolLabel.topAnchor),
            favouriteButton.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 6),
            
            digitView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 14),
            digitView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -12),
            digitView.heightAnchor.constraint(equalToConstant: 40),
            digitView.widthAnchor.constraint(equalToConstant: 100),
            
            priceLabel.topAnchor.constraint(equalTo: digitView.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: digitView.trailingAnchor),
            
            changePriceLabel.bottomAnchor.constraint(equalTo: companyLabel.bottomAnchor),
            changePriceLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor)
        ])
    }
}
