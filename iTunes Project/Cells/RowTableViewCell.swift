//
//  RowTableViewCell.swift
//  iTunes Project
//
//  Created by Manenga Mungandi on 2023/07/23.
//

import UIKit
import Foundation

class RowTableViewCell: UITableViewCell {

    private var userInterfaceStyle: UIUserInterfaceStyle {
        UserDefaults.standard.string(forKey: "theme") == "dark" ? .dark : .light
    }

    private var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing  = 10
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.isBaselineRelativeArrangement = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return stackView
    }()

    private var stackViewContent: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing  = 5
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private var stackViewFooter: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing  = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.isBaselineRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private var labelShortDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private var seeMoreButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()

    private var isSeeLess = true
    private var seeMoreDidTapHandler: (() -> Void)?

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

    @objc private func seeMoreButtonTapped() {
        self.isSeeLess.toggle()
        self.labelShortDescription.numberOfLines = self.isSeeLess ? 2 : 6
        self.labelShortDescription.layoutIfNeeded()
        self.seeMoreButton.setTitle(self.isSeeLess ? "See less" : "See more", for: .normal)
        layoutIfNeeded()
    }

    private func addViews() {
        stackViewContent.addArrangedSubview(labelSongTitle)
        stackViewContent.addArrangedSubview(labelArtistName)
        stackViewContent.addArrangedSubview(labelShortDescription)
        stackViewContent.addArrangedSubview(stackViewFooter)

        stackViewFooter.addArrangedSubview(labelReleaseDate)
        stackViewFooter.addArrangedSubview(seeMoreButton)

        stackViewContainer.addArrangedSubview(imageViewArtwork)
        stackViewContainer.addArrangedSubview(stackViewContent)
        contentView.addSubview(stackViewContainer)
    }

    func setupCell(with data: SearchItem) {
        labelSongTitle.text = data.trackName
        labelShortDescription.text = data.shortDescription
        imageViewArtwork.downloaded(from: data.artworkUrl100 ?? "")
        labelReleaseDate.text = data.releaseDate?.changeDateFormat()
        labelShortDescription.isHidden = (data.shortDescription ?? "").isEmpty
        labelArtistName.text = (data.kind?.capitalized ?? "") + " • " + (data.artistName ?? "")

        labelSongTitle.textColor = userInterfaceStyle == .light ? .black : .white
        labelArtistName.textColor = userInterfaceStyle == .light ? .black : .white
        labelReleaseDate.textColor = userInterfaceStyle == .light ? .black : .white
        labelShortDescription.textColor = userInterfaceStyle == .light ? .gray : .lightGray

        seeMoreButton.isHidden = data.shortDescription?.isEmpty ?? true
        seeMoreButton.setTitle(isSeeLess ? "See less" : "See more", for: .normal)
        seeMoreButton.setTitleColor(userInterfaceStyle == .light ? .black : .white, for: .normal)
        seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
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
