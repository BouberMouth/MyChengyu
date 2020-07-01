//
//  DictionnaryView.swift
//  I Learn Chengyus
//
//  Created by Antoine on 29/02/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class DictionnaryView: UIView {
    
    //MARK: - Properties
    
    var safeArea: UILayoutGuide!
    let searchBar = UISearchBar()
    let tableView = UITableView()

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
        safeArea = safeAreaLayoutGuide
        backgroundColor = UIColor(named: "ChengyuBackground")
        setupTableView()
        setupSearchBar()
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = tableView.topAnchor.constraint(equalTo: safeArea.topAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        NSLayoutConstraint.activate([top, leading, bottom, trailing])
        
        tableView.backgroundColor = UIColor(named: "ChengyuBackground")
        tableView.tableFooterView = UIView()
        
    }
    
    private func setupSearchBar() {
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let top = searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16)
        let leading = searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32)
        let trailing = searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32)
        let height = searchBar.heightAnchor.constraint(equalToConstant: 60)
        NSLayoutConstraint.activate([top, leading, trailing, height])
        
        //Make searchBar background and textfield transparent
        searchBar.backgroundImage = UIImage()
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.backgroundColor = UIColor(named: "ChengyuBackground")?.withAlphaComponent(0.9)
        
        searchBar.searchTextField.textColor = .chengyuWhite
        searchBar.searchTextField.tintColor = .chengyuWhite // sets cursor to white
        searchBar.setIconsColor(to: .chengyuWhite)
        
        searchBar.layer.cornerRadius = 30
        searchBar.layer.borderWidth = 2 // IDEA: change width when selecteds
        searchBar.layer.borderColor = UIColor.chengyuWhite.cgColor
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowRadius = 4
        searchBar.layer.shadowOffset = CGSize(width: 4, height: 4)
        searchBar.layer.shadowOpacity = 0.25
    }
}

