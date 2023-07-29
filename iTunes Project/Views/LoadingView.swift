//
//  LoadingView.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/30.
//

import UIKit

class LoadingView: UIView {
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .primary
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViews()
        setupViews()
    }

    private func addViews() {
        addSubview(activityIndicatorView)
    }

    private func setupViews() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}

