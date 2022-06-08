//
//  DetailsViewController.swift
//  Stocks
//
//  Created by  User on 28.05.2022.
//

import UIKit
import Charts

class DetailsViewController: UIViewController {
    
    var presenter: DetailsPresenterProtocol
    
    let favoriteService: FavoriteServiceProtocol = ModuleBuilder.shared.favoriteService
    
    var periodIndex: Int?

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
    
    private lazy var graphView: LineChartView = {
        let view = LineChartView()
        
        view.xAxis.drawLabelsEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.leftAxis.enabled = false
        view.rightAxis.drawGridLinesEnabled = false
        view.rightAxis.enabled = false
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var timeButtonView: UIStackView = {
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing   = 10.0
        
        let buttonsArray = ["W", "M", "6M", "1Y"].map {title in
            createCustomButton(title: title)
        }
        periodIndex = buttonsArray.count - 1
        
        var iter = 0
        buttonsArray.forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 44),
            ])
            $0.addTarget(self, action: #selector(timeButtonChoosed), for: .touchUpInside)
            stackView.addArrangedSubview($0)
            $0.tag = iter
            iter += 1
        }
        
        let label = buttonsArray.last?.subviews.first as? UILabel
        label?.textColor = .white
        buttonsArray.last?.backgroundColor = .black

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    func updateGraph (with details: DetailsModel) {
        guard let periodIndex = periodIndex else {
            return
        }

        showChart(with: details.periods[periodIndex])
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
        periodIndex = sender.tag
        presenter.loadView()
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
        
        graphView.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: graphView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: graphView.centerYAnchor)
        ])
    }
    
    @objc func popToPrevious(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func addToFavorite(_ sender: UIBarButtonItem) {
        presenter.stock.setFavorite()
        navigationItem.rightBarButtonItem?.tintColor = favoriteService.isFavorite(id: presenter.stock.id) ? .yellow : .lightGray
    }
    
    func showChart (with period: DetailsModel.Period?) {
        guard let period = period else {
            return
        }
        
        var yValues = [ChartDataEntry]()
        for (index, value) in period.prices.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index + 1), y: value)
            yValues.append(dataEntry)
        }
        
        let lineDataSet = LineChartDataSet(entries: yValues)
        lineDataSet.valueFont = .systemFont(ofSize: 16)
        lineDataSet.drawFilledEnabled = true
        lineDataSet.drawValuesEnabled = false
        lineDataSet.lineWidth = 5.0
        lineDataSet.mode = .cubicBezier
        lineDataSet.colors = [NSUIColor.black]
        lineDataSet.fillColor = .black
        lineDataSet.drawCirclesEnabled = false
        
        graphView.data = LineChartData(dataSets: [lineDataSet])
        graphView.animate(xAxisDuration: 0.3, yAxisDuration: 0.2)
    }

}

extension DetailsViewController: DetailsViewProtocol {
    func updateView(with details: DetailsModel) {
        updateGraph(with: details)
    }
    
    func updateView() {
    }
    
    func updateView(withLoader isLoading: Bool) {
        isLoading ? loader.startAnimating() : loader.stopAnimating()
    }
    
    func updateView(withError message: String) {
        
    }
    
    
}
