//
//  COTDView.swift
//  I Learn Chengyus
//
//  Created by Antoine on 07/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class COTDView: UIView {
    
    //MARK: - Properties
    
    let chengyuLabel = UILabel()
    let pinyinLabel = UILabel()
    let titleLabel = UILabel()

    //MARK: - Public methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(_ model: Chengyu?) {
        chengyuLabel.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.characterPreferenceKey) == "SIMP" ? model?.simpChengyu : model?.tradChengyu
        pinyinLabel.text = model?.pinyin
    }
    
    //MARK: - Private methods
    
    private func setupView() {
        setupTitleLabel()
        setupChengyuLabel()
        setupPinyinLabel()
        setupStackViews()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = String.localize(forKey: "MENU.COTD_TITLE")
        titleLabel.font = UIFont.roundedFont(ofSize: 20.0, weight: .bold)
        titleLabel.textColor = .chengyuWhite
    }

    
    private func setupChengyuLabel() {
        chengyuLabel.font = UIFont.roundedFont(ofSize: 60, weight: .bold)
        chengyuLabel.textColor = UIColor(named: "ChengyuText")
        chengyuLabel.shadowColor = UIColor.black.withAlphaComponent(0.1)
        chengyuLabel.shadowOffset = CGSize(width: 2, height: 2)
        
        print(chengyuLabel.textColor)
        print(UIColor.chengyuWhite)
    }
    
    private func setupPinyinLabel() {
        pinyinLabel.font = UIFont.roundedFont(ofSize: 20/*.subheadline*/, weight: .bold)
        pinyinLabel.textColor = UIColor.chengyuWhite.withAlphaComponent(0.5)
    }
    
    private func setupStackViews() {
        let chengyuStackView = UIStackView(arrangedSubviews: [chengyuLabel, pinyinLabel])
        chengyuStackView.axis = .vertical
        chengyuStackView.alignment = .center
        chengyuStackView.distribution = .fill
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, chengyuStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let centerX = stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        NSLayoutConstraint.activate([centerX, centerY])
    }
}
