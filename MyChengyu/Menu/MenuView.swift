//
//  MenuView.swift
//  I Learn Chengyus
//
//  Created by Antoine on 28/02/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class MenuView: UIView {
    
    //MARK: - Properties
    var buttonsNames: [String]? {
        didSet {
            setupButtons()
        }
    }
    let cotdView = COTDView()
    var menuButtons = [MenuButton]()
    var safeArea: UILayoutGuide!
    let stackView = UIStackView()
    
    //MARK: - Public methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: Chengyu?) {
        cotdView.setModel(model)
    }
    
    //MARK: - Private methods
    
    private func setupView() {
        safeArea = safeAreaLayoutGuide
        backgroundColor = UIColor(named: "ChengyuBackground")
        setupCOTDView()
        setupStackView()
    }
    
    private func setupCOTDView() {
        addSubview(cotdView)
        cotdView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = cotdView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        let leading = cotdView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16)
        let trailing = cotdView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        let height = cotdView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.3)
        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        let leading = stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16)
        let trailing = stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        let height = stackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.6)
        NSLayoutConstraint.activate([bottom, leading, trailing, height])
    }
    
    private func setupButtons() {
        guard let names = buttonsNames else {
            return
        }
        for tag in names.indices {
            let newButton = MenuButton()
            newButton.menuLabel.text = names[tag]
            newButton.tag = tag
            menuButtons.append(newButton)
            stackView.addArrangedSubview(newButton)
        }
    }
}



