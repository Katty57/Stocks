//
//  MainScreenViewController.swift
//  Stocks
//
//  Created by  User on 24.05.2022.
//

import UIKit

final class MainScreenViewController: UIViewController {

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
        let label = UILabel()
        label.text = "Stocks"
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-Bold", size: 28)
        self.navigationItem.titleView = label
        
        setUpSubviews()
        // Do any additional setup after loading the view.
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

extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.typeName, for: indexPath) as! StockTableViewCell
        cell.getIndex(index: indexPath.row)
        return cell
    }
   
}

extension NSObject {
    static var typeName: String {
        String(describing: self)
    }
}
