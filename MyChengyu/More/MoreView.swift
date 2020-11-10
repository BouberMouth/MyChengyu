//
//  MoreView.swift
//  MyChengyu
//
//  Created by Antoine on 10/11/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class MoreView: UIView {
    
    //MARK: - Properties
    let foldButton = UIButton()
    let tableView = UITableView()
    var safeArea: UILayoutGuide!

    //MARK: - Public methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFoldButtonAction(target: Any?, action: Selector) {
        foldButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    //MARK: - Private methods
    
    private func setupView() {
        safeArea = safeAreaLayoutGuide
        backgroundColor = UIColor(named: "ChengyuBackground")
        
        setupFoldButton()
        setupTableView()
    }
    
    func setupFoldButton() {
        addSubview(foldButton)
        foldButton.translatesAutoresizingMaskIntoConstraints = false
        
        let top = foldButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8)
        let centerX = foldButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        let width = foldButton.widthAnchor.constraint(equalToConstant: 30)
        let height = foldButton.heightAnchor.constraint(equalToConstant: 15)
        NSLayoutConstraint.activate([top, width, centerX, height])
        
        foldButton.backgroundColor = UIColor(named: "ChengyuBackground")
        foldButton.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        foldButton.tintColor = UIColor.chengyuWhite.withAlphaComponent(0.5)
        foldButton.contentHorizontalAlignment = .fill
        foldButton.contentVerticalAlignment = .fill
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = tableView.topAnchor.constraint(equalTo: foldButton.bottomAnchor, constant: 0)
        let leading = tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
        tableView.backgroundColor = UIColor(named: "ChengyuBackground")
    }
}
