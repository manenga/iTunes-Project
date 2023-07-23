//
//  RowTableViewCell.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import UIKit
import Foundation

class RowTableViewCell: UITableViewCell {

    private var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing  = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.isBaselineRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing  = 5
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private var imageViewArtwork: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "defaultArtwork")
        return imageView
    }()

    private var labelSongTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    private var labelArtistName: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private var labelReleaseDate: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.layoutMargins.bottom = 15
        return label
    }()

    private var labelShortDescription: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        constrainViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }

    private func addViews() {
        stackViewContent.addArrangedSubview(labelSongTitle)
        stackViewContent.addArrangedSubview(labelArtistName)
        stackViewContent.addArrangedSubview(labelReleaseDate)
        stackViewContent.addArrangedSubview(labelShortDescription)

        stackViewContainer.addArrangedSubview(imageViewArtwork)
        stackViewContainer.addArrangedSubview(stackViewContent)
        contentView.addSubview(stackViewContainer)
    }

    func setupCell(with data: SearchResult) {
        labelSongTitle.text = data.trackName
        labelArtistName.text = data.artistName
        labelReleaseDate.text = data.releaseDate
        labelShortDescription.text = data.shortDescription
        imageViewArtwork.downloaded(from: data.artworkUrl100 ?? "")

        layoutIfNeeded()
    }

    private func constrainViews() {
        NSLayoutConstraint.activate([
            stackViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageViewArtwork.widthAnchor.constraint(equalToConstant: 100),
            imageViewArtwork.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
