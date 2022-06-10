//
//  SearchViewController.swift
//  Stocks
//
//  Created by  User on 10.06.2022.
//

import Foundation
import UIKit

final class SearchViewController: UIViewController {
    
    private var presenter: SearchPresenterProtocol
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.tintColor = .black
        textField.addTarget(self, action: #selector(showTableView), for: .editingChanged)
        return textField
    }()
    
    private lazy var searchDeleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "searchDelete"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(clearInput), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.black.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        [searchTextField, searchDeleteButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.register(StockTableViewCell.self, forCellReuseIdentifier: StockTableViewCell.typeName)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var spaceTableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        return tapGesture
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(presenter: SearchPresenterProtocol) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func showTableView(_ sender: UITextField) {
        if let text = sender.text, text.isEmpty {
            searchDeleteButton.isHidden = true
        } else {
            searchDeleteButton.isHidden = false
        }
        
        presenter.loadView(with: sender.text)
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 28)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 16)!]
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
        view.gestureRecognizers = nil
    }
    
    @objc private func clearInput(_ sender: UIButton) {
        searchTextField.text = nil
        view.gestureRecognizers = nil
        sender.isHidden = true
        presenter.loadView(with: nil)
    }
    
    private func setUpSubviews() {
        view.addSubview(searchView)
        spaceTableView.addSubview(tableView)
        view.addSubview(loader)
        view.addSubview(spaceTableView)
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchView.heightAnchor.constraint(equalToConstant: 48),
            
            spaceTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 24),
            spaceTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spaceTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spaceTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: spaceTableView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: spaceTableView.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: spaceTableView.trailingAnchor, constant: -16.0),
            tableView.bottomAnchor.constraint(equalTo: spaceTableView.bottomAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 17),
            searchTextField.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 18),
            searchTextField.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -17),
            searchTextField.trailingAnchor.constraint(equalTo: searchDeleteButton.leadingAnchor, constant: 10),
            
            searchDeleteButton.topAnchor.constraint(equalTo: searchView.topAnchor, constant: 17),
            searchDeleteButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -18),
            searchDeleteButton.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -17),
            searchDeleteButton.widthAnchor.constraint(equalToConstant: 16),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension SearchViewController: SearchViewProtocol {
    
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

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        presenter.loadView(with: text + string)
        view.addGestureRecognizer(tapGesture)
        return true
    }
}
