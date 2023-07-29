//
//  NoResultsView.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/29.
//

import UIKit

class NoResultsView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupViews()
        constrainViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addViews()
        setupViews()
        constrainViews()
    }

    private func addViews() {
        addSubview(titleLabel)
    }

    private func setupViews() {
        backgroundColor = .clear
    }

    private func constrainViews() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
        ])
    }

    func setEmptyMessage(_ message: String) {
        titleLabel.text = message
    }
}
