//
//  DictionnaryTableViewCell.swift
//  I Learn Chengyus
//
//  Created by Antoine on 07/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class ChengyuTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    var chengyu: Chengyu? {
        didSet {
            chengyuLabel.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.characterPreferenceKey) == "SIMP" ? chengyu?.simpChengyu : chengyu?.tradChengyu
            pinyinLabel.text = chengyu?.pinyin
            definitionLabel.text = chengyu?.definitions.first
        }
    }
    let chengyuLabel = UILabel()
    let definitionLabel = UILabel()
    let pinyinLabel = UILabel()

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
        setupChengyuLabel()
        setupPinyinLabel()
        setupDefinitionLabel()
        setupStackView()
        
        
        layoutIfNeeded()
        layoutSubviews()
    }
    
    private func setupChengyuLabel() {
        chengyuLabel.font = UIFont.roundedFont(ofSize: 30/*.title1*/, weight: .bold)
        chengyuLabel.textColor = .chengyuWhite
    }
    
    private func setupPinyinLabel() {
        pinyinLabel.font = UIFont.roundedFont(ofSize: 24/*.title2*/, weight: .light)
        pinyinLabel.textColor = UIColor.chengyuWhite.withAlphaComponent(0.5)
    }
    
    private func setupDefinitionLabel() {
        definitionLabel.font = UIFont.roundedFont(ofSize: 24/*.title2*/, weight: .light)
        definitionLabel.textColor = .chengyuWhite
    }
    
    private func setupStackView() {
        let topStackView = UIStackView(arrangedSubviews: [chengyuLabel, pinyinLabel])
        topStackView.axis = .horizontal
        topStackView.alignment = .bottom
        topStackView.distribution = .fill
        topStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [topStackView, definitionLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let top = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        let leading = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        let bottom = stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        let trailing = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        NSLayoutConstraint.activate([top, leading, bottom, trailing])

//        let height = stackView.heightAnchor.constraint(equalTo: heightAnchor, constant: -16)
//        let width = stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -16)
//        let centerY = stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        let centerX = stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
//        NSLayoutConstraint.activate([height, width, centerY, centerX])
    }
}

