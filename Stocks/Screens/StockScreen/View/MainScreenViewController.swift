//
//  MainScreenViewController.swift
//  Stocks
//
//  Created by  User on 24.05.2022.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    private var stocks = [Stock]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
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
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let label = UILabel()
        label.text = "Stocks"
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-Bold", size: 28)
        self.navigationItem.titleView = label
        let barItem = UITabBarItem()
        barItem.image = UIImage(named: "diagram")
        self.tabBarItem = barItem

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        setUpSubviews()
        getStocks()
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
    
    private func getStocks() {
        let client = Network()
        let service: StockServiceProtocol = StockService(client: client)
        
        service.getStocks { result in
            switch result {
            case .success(let stocks):
                self.stocks = stocks.map { stock in
                    return Stock(id: stock.id, symbol: stock.symbol, name: stock.name, image: stock.image, price: round(stock.price * 100) / 100, change: round(stock.change * 100) / 100, changePercentage: round(stock.changePercentage * 100) / 100)
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.typeName, for: indexPath) as? StockTableViewCell else {return UITableViewCell()}
        cell.getIndex(index: indexPath.row)
        cell.configure(with: stocks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController(stock: stocks[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: false)
    }
}






