//
//  ViewController.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import UIKit
import Combine
import SwiftUI

class HomeViewController: UIViewController {

    @ObservedObject private var viewModel = HomeViewModel()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing  = 10
        stackView.distribution = .fill
        return stackView
    }()

    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.prompt = "Search For Songs, Artists and Albums"
        searchBar.autocapitalizationType = .words
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "e.g Aqua Barbie Girl"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()


    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RowTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupViews()
        constrainViews()
    }

    private func addViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(tableView)
    }

    private func setupViews() {
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        navigationItem.title = "iTunes Library"
        navigationItem.titleView?.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    private func constrainViews() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 80),
            tableView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrint(searchText)
        viewModel.searchTerm(searchText)
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RowTableViewCell
        if !viewModel.results.isEmpty && viewModel.results.count > indexPath.row {
            let data = viewModel.results[indexPath.row]
            cell.setupCell(with: data)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !viewModel.results.isEmpty && viewModel.results.count > indexPath.row {
            let data = viewModel.results[indexPath.row]
            return (data.shortDescription ?? "").count > 100 ? 300 : 150

        }
        return 150
    }
}
