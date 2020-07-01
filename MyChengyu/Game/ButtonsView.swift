//
//  ButtonsView.swift
//  I Learn Chengyus
//
//  Created by Antoine on 14/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class ButtonsView: UIView {
    //MARK: - Properties
    
    var model: ButtonViewModel? {
        didSet {
            setupButtonRows()
        }
    }
    var stackView: UIStackView!
    var buttonRows: [UIStackView]?
    var buttons = [GameButton]()
    
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
        setupStackView()
    }
    
    private func setupStackView() {
        guard let buttonRows = buttonRows else { return }

        stackView = UIStackView(arrangedSubviews: buttonRows)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = stackView.topAnchor.constraint(equalTo: topAnchor)
        let leading = stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let trailing = stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([top, leading, bottom, trailing])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
    }
    
    private func setupButtonRows() {
        guard let model = model else { return }
        buttons.removeAll()
        buttonRows = [UIStackView]()
        
        for _ in 0..<model.numberOfRows {
            var newButtons = [GameButton]()
            for _ in 0..<model.numberOfColumns {
                let button = GameButton()
                newButtons.append(button)
                buttons.append(button)
            }
            
            let hStackView = UIStackView(arrangedSubviews: newButtons)
            hStackView.axis = .horizontal
            hStackView.alignment = .fill
            hStackView.distribution = .fillEqually
            hStackView.spacing = 8
            
            buttonRows?.append(hStackView)
        }
        setupStackView()
    }
}

class GameButton: UIButton {
    //MARK: - Properties
    
    var hasBeenSelected: Bool = false {
        didSet {
            updateButtonAppearance(hasBeenSelected)
        }
    }
    
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
        layer.cornerRadius = 8
        layer.borderColor = UIColor.chengyuWhite.cgColor
        layer.borderWidth = 1
        titleLabel?.font = UIFont.systemFont(ofSize: 25)
    }
    
    private func updateButtonAppearance(_ isSelected: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.backgroundColor = isSelected ? .chengyuWhite : UIColor(named: "ChengyuBackground")
            self?.setTitleColor(isSelected ? UIColor(named: "ChengyuBackground") : .chengyuWhite, for: .normal)
            self?.layer.borderColor = isSelected ?
                UIColor(named: "ChengyuBackground")?.cgColor : UIColor.chengyuWhite.cgColor
        }
    }
    
}

struct ButtonViewModel {
    //MARK: - Properties
    
    let numberOfRows: Int
    let numberOfColumns: Int
    
    //MARK: - Methods
    
    init(forLevel level: Level) {
        switch level {
        case .oneByOne:
            self.numberOfRows = 2
            self.numberOfColumns = 2
        case .threeByThree:
            self.numberOfRows = 4
            self.numberOfColumns = 3
        case .fiveByFive:
            self.numberOfRows = 5
            self.numberOfColumns = 4
        }
    }
}
