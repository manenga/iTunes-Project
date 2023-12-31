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
        stackView.axis = .vertical
        stackView.spacing  = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.returnKeyType = .search
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .words
        searchBar.prompt = "Search For Songs, Artists and Albums"
        searchBar.placeholder = "What do you want to listen to?"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .primary
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RowTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private var noResultsView: NoResultsView = {
        let emptyResultsView = NoResultsView()
        emptyResultsView.setEmptyMessage("Wow! Such empty.")
        emptyResultsView.translatesAutoresizingMaskIntoConstraints = false
        return emptyResultsView
    }()

    private var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    private var userInterfaceStyle: UIUserInterfaceStyle {
        UserDefaults.standard.string(forKey: "theme") == "light" ? .light : .dark
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupViews()
        constrainViews()
    }

    private func addViews() {
        view.addSubview(stackView)
        view.addSubview(noResultsView)
        view.addSubview(loadingView)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(tableView)
    }

    private func setupViews() {
        setupNavigation()
        setupUserInterfaceStyle()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    private func setupNavigation() {
        navigationItem.title = "iTunes Library"
        let modeToggle = UIBarButtonItem(image: UIImage(systemName: "sun.dust.circle.fill"), style: .plain, target: self, action: #selector(appearanceSwitch))
        let aboutAppIcon = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle.fill"), style: .plain, target: self, action: #selector(showAboutAppScreen))
        navigationItem.rightBarButtonItems = [aboutAppIcon, modeToggle]
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primary]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    private func constrainViews() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 80),
            tableView.heightAnchor.constraint(equalToConstant: 500),
            loadingView.topAnchor.constraint(equalTo: tableView.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            noResultsView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            noResultsView.leadingAnchor.constraint(greaterThanOrEqualTo: tableView.leadingAnchor, constant: 16),
            noResultsView.trailingAnchor.constraint(lessThanOrEqualTo: tableView.trailingAnchor, constant: -16)
        ])
    }

    private func setupUserInterfaceStyle() {
        if userInterfaceStyle == .light {
            view.backgroundColor = .white
            overrideUserInterfaceStyle = .light

        } else {
            view.backgroundColor = .black
            overrideUserInterfaceStyle = .dark
        }
    }

    @objc private func appearanceSwitch() {
        if userInterfaceStyle == .dark {
            UserDefaults.standard.set("light", forKey: "theme")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.window?.overrideUserInterfaceStyle = .light
        } else {
            UserDefaults.standard.set("dark", forKey: "theme")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.window?.overrideUserInterfaceStyle = .dark
        }
        UserDefaults.standard.synchronize()
        setupUserInterfaceStyle()
        tableView.reloadData()
    }

    @objc private func showAboutAppScreen() {
        let alert = UIAlertController(
            title: "About this app",
            message: "This is a simple app that makes use of the iTunes API to search for any song on the entire iTunes catalog.",
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadingView.startAnimating()
        loadingView.isHidden = false
        noResultsView.isHidden = true

        viewModel.searchTerm(searchBar.text ?? "")
        searchBar.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.tableView.reloadData()
            self?.loadingView.stopAnimating()
            self?.loadingView.isHidden = true
        }
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
        noResultsView.isHidden = viewModel.results.startIndex != viewModel.results.endIndex
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
