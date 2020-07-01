//
//  AddDeckButtonCell.swift
//  I Learn Chengyus
//
//  Created by Antoine on 07/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class AddDeckButtonCell: UITableViewCell {
    
    //MARK: - Properties
    
    let button = UIButton()
    
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
        setupButton()
    }
    
    private func setupButton() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = button.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = button.centerYAnchor.constraint(equalTo: centerYAnchor)
        let height = button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        let width = button.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        NSLayoutConstraint.activate([centerY, centerX, height, width])
        
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .chengyuWhite
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
    }
}

