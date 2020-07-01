//
//  CarousselCell.swift
//  I Learn Chengyus
//
//  Created by Antoine on 13/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class CarousselView: UICollectionView {
    //MARK: - Methods
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor =  UIColor(named: "GameBackground")
    }
    
}

class CarousselCell: UICollectionViewCell {
    //MARK: - Properties
    let label = UILabel()
    
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
        backgroundColor = UIColor(named: "ChengyuBackground")
        layer.borderColor = UIColor.chengyuWhite.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 16
        setupLabel()
    }
    
    private func setupLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let top = label.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        let leading = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        let bottom = label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        let trailing = label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        NSLayoutConstraint.activate([top, leading, bottom, trailing])
        
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.roundedFont(ofSize: 20/*.body*/, weight: .regular)
    }
}
