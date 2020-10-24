//
//  ChengyuDetailsView.swift
//  I Learn Chengyus
//
//  Created by Antoine on 01/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class ChengyuDetailsView: UIView {
    
    //MARK: - Properties
    let addButton = UIButton()
    let chengyuLabel = UILabel()
    let copyButton = UIButton()
    let definitionTextView = UITextView()
    let favoriteButton = UIButton()
    var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    let pinyinLabel = UILabel()
    var safeArea: UILayoutGuide!
    let topContainerView = UIView()

    //MARK: - Public methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: Chengyu?) {
        chengyuLabel.text = model?.preferredForm()
        pinyinLabel.text = model?.pinyin
        if let formattedDefinitions = model?.definitions.map({"• " + $0}) {
            definitionTextView.text = "\n" + formattedDefinitions.joined(separator: "\n")
        }
        isFavorite = model?.isFavorite ?? false
    }
    
    //MARK: - Private methods
    
    private func setupView() {
        safeArea = safeAreaLayoutGuide
        backgroundColor = .chengyuWhite
        setupTopContainerView()
        setupPinyinLabel()
        setupChengyuLabel()
        setupCopyButton()
        setupAddButton()
        setupFavoriteButton()
        setupDefinitionTextView()
    }
    
    private func setupTopContainerView() {
        addSubview(topContainerView)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = topContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -16)
        let leading = topContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0)
        let trailing = topContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0)
        let height = topContainerView.heightAnchor.constraint(equalToConstant: 130)
        NSLayoutConstraint.activate([top, leading, trailing, height])
        
        topContainerView.backgroundColor = UIColor(named: "ChengyuBackground")
        topContainerView.layer.shadowColor = UIColor.black.cgColor
        topContainerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        topContainerView.layer.shadowOpacity = 0.25
        topContainerView.layer.shadowRadius = 4
        topContainerView.layer.cornerRadius = 15
    }
    
    private func setupPinyinLabel() {
        topContainerView.addSubview(pinyinLabel)
        pinyinLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = pinyinLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -16)
        let leading = pinyinLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 16)
        NSLayoutConstraint.activate([bottom, leading])
        
        pinyinLabel.font = UIFont.roundedFont(ofSize: 24/*.title2*/, weight: .light)
        pinyinLabel.textColor = UIColor.chengyuWhite.withAlphaComponent(0.5)
    }
    
    private func setupChengyuLabel() {
        topContainerView.addSubview(chengyuLabel)
        chengyuLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = chengyuLabel.bottomAnchor.constraint(equalTo: pinyinLabel.topAnchor, constant: 0)
        let leading = chengyuLabel.leadingAnchor.constraint(equalTo: pinyinLabel.leadingAnchor)
        NSLayoutConstraint.activate([bottom, leading])
        
        chengyuLabel.font = UIFont.roundedFont(ofSize: 36/*.title0*/, weight: .bold)
        chengyuLabel.textColor = .chengyuWhite
    }
    
    private func setupDefinitionTextView() {
        addSubview(definitionTextView)
        definitionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = definitionTextView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -16)
        let leading = definitionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8)
        let trailing = definitionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        let bottom = definitionTextView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -8)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
        definitionTextView.backgroundColor = .chengyuWhite
        definitionTextView.textColor = .chengyuBlack
        definitionTextView.font = UIFont.roundedFont(ofSize: 24/*.title2*/, weight: .light)
        definitionTextView.isEditable = false
        
        bringSubviewToFront(topContainerView)
    }
    
    private func setupCopyButton() {
        addSubview(copyButton)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = copyButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        let leading = copyButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16)
        let height = copyButton.heightAnchor.constraint(equalToConstant: 40)
        let width = copyButton.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([bottom, leading, height, width])
        
        copyButton.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .normal)
        copyButton.tintColor = UIColor(named: "ChengyuBackground")
        copyButton.contentHorizontalAlignment = .fill
        copyButton.contentVerticalAlignment = .fill
    }
    
    private func setupAddButton() {
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = addButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        let centerX = addButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        let height = addButton.heightAnchor.constraint(equalToConstant: 40)
        let width = addButton.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([bottom, centerX, height, width])
        
        addButton.setImage(UIImage(systemName: "plus.square.fill"), for: .normal)
        addButton.tintColor = UIColor(named: "ChengyuBackground")
        addButton.contentHorizontalAlignment = .fill
        addButton.contentVerticalAlignment = .fill
    }
    
    private func setupFavoriteButton() {
        addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = favoriteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        let trailing = favoriteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        let height = favoriteButton.heightAnchor.constraint(equalToConstant: 40)
        let width = favoriteButton.widthAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([bottom, trailing, height, width])
        
        favoriteButton.tintColor = UIColor(named: "ChengyuBackground")
        favoriteButton.contentHorizontalAlignment = .fill
        favoriteButton.contentVerticalAlignment = .fill
    }
}

