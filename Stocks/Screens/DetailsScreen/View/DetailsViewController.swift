//
//  DetailsViewController.swift
//  Stocks
//
//  Created by  User on 28.05.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var presenter: DetailsPresenterProtocol
    
    let favoriteService: FavoriteServiceProtocol = ModuleBuilder.shared.favoriteService

    private lazy var navBarTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
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
    
    private lazy var titleView: UIView = {
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleView.addSubview(companyLabel)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            
            companyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            companyLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            
            titleView.heightAnchor.constraint(equalToConstant: 44)
        ])
        navigationItem.titleView = titleView
        return titleView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 28)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceView: UIView = {
        let view = UIView()
        view.addSubview(priceLabel)
        view.addSubview(changeLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: view.topAnchor),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            changeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        return view
    }()
    
    private lazy var graphView: UIView = {
        let view = UIView()
        
        let label = UILabel()
        label.text = "Graph"
        label.font = UIFont(name: "Montserrat-Bold", size: 38)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var timeButtonView: UIStackView = {
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing   = 10.0
        
        let buttonsArray = ["D", "W", "M", "6M", "1Y", "All"].map {title in
            createCustomButton(title: title)
        }
        
        buttonsArray.forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 44),
                $0.widthAnchor.constraint(equalToConstant: 42)
            ])
            $0.addTarget(self, action: #selector(timeButtonChoosed), for: .touchUpInside)
            stackView.addArrangedSubview($0)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buyButton: UIButton = {
        let button = createCustomButton(title: "Buy for " + presenter.stock.price, size: 16, textColor: .white, buttonColor: .black, cornerRadius: 16)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: DetailsPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpSubviews()
        presenter.loadView()
        configure()
        // Do any additional setup after loading the view.
    }
    
    func setUpView () {
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .plain, target: self, action: #selector(popToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(addToFavorite))
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func configure () {
        titleLabel.text = presenter.stock.symbol
        companyLabel.text = presenter.stock.name
        priceLabel.text = presenter.stock.price
        changeLabel.text = presenter.stock.change
        changeLabel.textColor = presenter.stock.changeColor
        navigationItem.rightBarButtonItem?.tintColor = favoriteService.isFavorite(id: presenter.stock.id) ? .yellow : .lightGray
    }
    
    @objc func timeButtonChoosed(_ sender: UIButton) {
        timeButtonView.arrangedSubviews.forEach {
            $0.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0)
            let label = $0.subviews.first as? UILabel
            label?.textColor = .black
        }
        sender.backgroundColor = .black
        let label = sender.subviews.first as? UILabel
        label?.textColor = .white
    }
    
    func createCustomButton(title: String, size: CGFloat = 12, textColor: UIColor = .black,
                            buttonColor: UIColor = UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0),
                            cornerRadius: CGFloat = 12) -> UIButton {
        let button = UIButton()
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: size)
        label.text = title
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        return button
    }
    
    func setUpSubviews() {
        [priceView, graphView, timeButtonView, buyButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            priceView.topAnchor.constraint(equalTo: view.topAnchor, constant: 162),
            priceView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceView.heightAnchor.constraint(equalToConstant: 56),
            
            graphView.topAnchor.constraint(equalTo: priceView.bottomAnchor, constant: 30),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphView.heightAnchor.constraint(greaterThanOrEqualToConstant: 260),
            
            timeButtonView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 40),
            timeButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            timeButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            buyButton.topAnchor.constraint(equalTo: timeButtonView.bottomAnchor, constant: 52),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            buyButton.heightAnchor.constraint(equalToConstant: 56)
        
        ])
    }
    
    @objc func popToPrevious(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func addToFavorite(_ sender: UIBarButtonItem) {
        presenter.stock.setFavorite()
        navigationItem.rightBarButtonItem?.tintColor = favoriteService.isFavorite(id: presenter.stock.id) ? .yellow : .lightGray
    }

}

extension DetailsViewController: DetailsViewProtocol {
    func updateView() {
    }
    
    func updateView(withLoader isLoading: Bool) {
        
    }
    
    func updateView(withError message: String) {
        
    }
    
    
}
