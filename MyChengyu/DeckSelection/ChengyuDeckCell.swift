//
//  ChengyuDeckCell.swift
//  I Learn Chengyus
//
//  Created by Antoine on 01/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class ChengyuDeckCell: UITableViewCell {
    
    //MARK: - Properties
    
    let iconImageView = UIImageView()
    let nameLabel = UILabel()
    let numberLabel = UILabel()

    //MARK: - Public methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setupView() {
        backgroundColor = UIColor(named: "ChengyuBackground")
        selectionStyle = .none
        setupNameLabel()
        setupNumberLabel()
        setupIconImageView()
        setupStackViews()
    }
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let leading = nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        NSLayoutConstraint.activate([leading])

        nameLabel.font = UIFont.roundedFont(ofSize: 30/*.title1*/, weight: .bold)
        nameLabel.textColor = .chengyuWhite
    }
    
    private func setupNumberLabel() {
        numberLabel.font = UIFont.roundedFont(ofSize: 24/*.title2*/, weight: .light)
        numberLabel.textColor = .chengyuWhite
    }
    
    private func setupIconImageView() {
        iconImageView.image = UIImage(systemName: "chevron.right")
        iconImageView.tintColor = .chengyuWhite
    }
    
    private func setupStackViews() {
        let leftStackView = UIStackView(arrangedSubviews: [nameLabel, numberLabel])
        leftStackView.axis = .vertical
        leftStackView.alignment = .leading
        leftStackView.distribution = .fill
        
        let stackView = UIStackView(arrangedSubviews: [leftStackView, iconImageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
}

