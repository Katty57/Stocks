//
//  MainScreenViewController.swift
//  Stocks
//
//  Created by  User on 24.05.2022.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    private let presenter: StocksPresenterProtocol
    
    init(presenter: StocksPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: StockTableViewCell.typeName)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var spaceTableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        presenter.loadView()
        setUpSubviews() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setUpView() {
        self.navigationItem.title = "Stocks"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 28)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 16)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpSubviews() {
        view.addSubview(spaceTableView)
        view.addSubview(loader)
        spaceTableView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            spaceTableView.topAnchor.constraint(equalTo: view.topAnchor),
            spaceTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spaceTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spaceTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: spaceTableView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: spaceTableView.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: spaceTableView.trailingAnchor, constant: -16.0),
            tableView.bottomAnchor.constraint(equalTo: spaceTableView.bottomAnchor),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.stockCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.typeName, for: indexPath) as? StockTableViewCell else {return UITableViewCell()}
        cell.getIndex(index: indexPath.row)
        cell.configure(with: presenter.model(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presenter = DetailsPresenter(stock: self.presenter.model(for: indexPath))
        let vc = DetailsViewController(presenter: presenter)
        presenter.view = vc
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension MainScreenViewController: StocksViewProtocol {
    func updateCell(for indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updateView() {
        tableView.reloadData()
    }
    
    func updateView(withLoader isLoading: Bool) {
        isLoading ? loader.startAnimating() : loader.stopAnimating()
    }
    
    func updateView(withError message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(ok)
        self.present(errorAlert, animated: true, completion: nil)
    }
}
