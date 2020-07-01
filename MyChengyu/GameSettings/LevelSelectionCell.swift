//
//  LevelSelectionCell.swift
//  I Learn Chengyus
//
//  Created by Antoine on 10/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class LevelSelectionCell: UITableViewCell {

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
        setupLabel()
    }
    
    private func setupLabel() {
        textLabel?.font = UIFont.roundedFont(ofSize: 30/*.title1*/, weight: .bold)
        textLabel?.textColor = .chengyuWhite
    }
}

