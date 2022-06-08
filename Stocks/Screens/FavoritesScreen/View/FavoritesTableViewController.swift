//
//  FavoritesTableViewController.swift
//  Stocks
//
//  Created by  User on 07.06.2022.
//

import UIKit

class FavoritesTableViewController: UIViewController {
    
    private let presenter: StocksPresenterProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(StockTableViewCell.self, forCellReuseIdentifier: StockTableViewCell.typeName)
        return tableView
    }()
    
    private lazy var spaceTableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        presenter.loadView()
        setUpSubviews()
    }
    
    init(presenter: StocksPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView () {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        navigationItem.title = "Favourite"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 28)!]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 16)!]
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUpSubviews() {
        view.addSubview(spaceTableView)
        spaceTableView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            spaceTableView.topAnchor.constraint(equalTo: view.topAnchor),
            spaceTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spaceTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spaceTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: spaceTableView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: spaceTableView.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: spaceTableView.trailingAnchor, constant: -16.0),
            tableView.bottomAnchor.constraint(equalTo: spaceTableView.bottomAnchor)
            
        ])
    }
    
}

extension FavoritesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.stockCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.typeName, for: indexPath) as? StockTableViewCell else {return UITableViewCell()}
        cell.getIndex(index: indexPath.row)
        cell.configure(with: presenter.model(for: indexPath))
        return cell
    }
}

extension FavoritesTableViewController: StocksViewProtocol {
    func updateCell(for indexPath: IndexPath) {
        
    }
    
    func updateView() {
        
        tableView.reloadData()
    }
    
    func updateView(withLoader isLoading: Bool) {
        
    }
    
    func updateView(withError message: String) {
        
    }
}
