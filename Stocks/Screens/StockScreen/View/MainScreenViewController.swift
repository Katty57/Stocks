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
//                self.stocks = stocks
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
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.typeName, for: indexPath) as! StockTableViewCell
        cell.getIndex(index: indexPath.row)
        cell.configure(with: stocks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController(stock: stocks[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension NSObject {
    static var typeName: String {
        String(describing: self)
    }
}

struct Stock: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    var price: Double
    let change: Double
    let changePercentage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case price = "current_price"
        case change = "price_change_24h"
        case changePercentage = "price_change_percentage_24h"
        
    }
}

//{   "id":"bitcoin",
//    "symbol":"btc",
//    "name":"Bitcoin",
//    "image":"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
//    "current_price":28568,
//    "market_cap":544147873414,
//    "market_cap_rank":1,
//    "fully_diluted_valuation":599817948333,
//    "total_volume":30074346781,
//    "high_24h":29681,
//    "low_24h":28563,
//    "price_change_24h":-1001.0801840990098,
//    "price_change_percentage_24h":-3.38561,
//    "market_cap_change_24h":-18982635564.56256,
//    "market_cap_change_percentage_24h":-3.37091,
//    "circulating_supply":19050956.0,
//    "total_supply":21000000.0,
//    "max_supply":21000000.0,
//    "ath":69045,
//    "ath_change_percentage":-58.29884,
//    "ath_date":"2021-11-10T14:24:11.849Z",
//    "atl":67.81,"atl_change_percentage":42361.1355,
//    "atl_date":"2013-07-06T00:00:00.000Z",
//    "roi":null,
//    "last_updated":"2022-05-27T17:34:14.561Z"}


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
