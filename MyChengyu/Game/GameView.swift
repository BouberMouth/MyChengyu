//
//  GameView.swift
//  I Learn Chengyus
//
//  Created by Antoine on 10/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class GameView: UIView {
    
    //MARK: - Properties
    
    var safeArea: UILayoutGuide!
    var exitButton = UIButton()
    var scoreLabel = UILabel()
    var carousselView: CarousselView!
    var buttonsView = ButtonsView()
    var buttons: [GameButton] {
        return buttonsView.buttons
    }
    
    //MARK: - Public Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setupView() {
        safeArea = safeAreaLayoutGuide
        backgroundColor = UIColor(named: "GameBackground")
        setupScoreLabel()
        setupExitButton()
        setupCarousselView()
        setupButtonView()
    }
    
    private func setupScoreLabel() {
        addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let top = scoreLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8)
        let centerX = scoreLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        NSLayoutConstraint.activate([top, centerX])
        
        scoreLabel.textColor = UIColor(named: "GameControl")
        scoreLabel.font = UIFont.roundedFont(ofSize: 24, weight: .semibold)
    }
    
    private func setupExitButton() {
        addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        let top = exitButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8)
        let trailing = exitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        let bottom = exitButton.bottomAnchor.constraint(equalTo: scoreLabel.bottomAnchor)
        let width = exitButton.widthAnchor.constraint(equalTo: scoreLabel.heightAnchor)
        NSLayoutConstraint.activate([top, trailing, width, bottom])
        
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.tintColor = UIColor(named: "GameControl")
    }
    
    private func setupCarousselView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        carousselView = CarousselView(frame: .zero, collectionViewLayout: layout)
        addSubview(carousselView)
        carousselView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = carousselView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 8)
        let leading = carousselView.leadingAnchor.constraint(equalTo: leadingAnchor)
        let bottom = carousselView.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -8)
        let trailing = carousselView.trailingAnchor.constraint(equalTo: trailingAnchor)
        NSLayoutConstraint.activate([top, leading, bottom, trailing])
        
        carousselView.showsHorizontalScrollIndicator = false
    }
    
    private func setupButtonView() {
        addSubview(buttonsView)
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = buttonsView.topAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: 8)
        let leading = buttonsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8)
        let trailing = buttonsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8)
        let bottom = buttonsView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
}

