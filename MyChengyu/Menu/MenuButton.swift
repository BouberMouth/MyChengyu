//
//  MenuButtonsCell.swift
//  I Learn Chengyus
//
//  Created by Antoine on 07/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class MenuButton: UIView {
    
    //MARK: - Properties
    
    let containerView = UIView()
    let menuImageView = UIImageView()
    let menuLabel = UILabel()

    //MARK: - Public methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setupView() {
        setupContainerView()
        setupMenuImageView()
        setupMenuLabel()
        
        backgroundColor = UIColor(named: "ChengyuBackground")
        layer.borderColor = UIColor.chengyuWhite.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 16
    }
    
    private func setupContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        let leading = containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        let bottom = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        let trailing = containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
    
    private func setupMenuLabel() {
        containerView.addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = menuLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        let leading = menuLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32)
        let trailing = menuLabel.trailingAnchor.constraint(lessThanOrEqualTo: menuImageView.leadingAnchor, constant: -8)
        NSLayoutConstraint.activate([centerY, leading, trailing])
        
        menuLabel.font = UIFont.roundedFont(ofSize: 24, weight: .bold)
        menuLabel.textColor = .chengyuWhite
        menuLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupMenuImageView() {
        addSubview(menuImageView)
        menuImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = menuImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let trailing = menuImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        NSLayoutConstraint.activate([centerY, trailing])
        
        menuImageView.image = UIImage(systemName: "chevron.right")
        menuImageView.tintColor = .chengyuWhite
    }
}

