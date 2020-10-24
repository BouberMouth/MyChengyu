//
//  DictionnaryVC.swift
//  I Learn Chengyus
//
//  Created by Antoine on 29/02/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

final class DictionnaryVC: UIViewController {
    
    //MARK: - Properties
    var allChengyus: [Chengyu]?
    var dictionnaryView: DictionnaryView!
    var filter: String?
    var filteredChengyus: [Chengyu]? {
        if let filter = filter {
            return allChengyus?.filter {
                $0.pinyin.folding(options: .diacriticInsensitive, locale: nil).lowercased().contains(filter) ||
                $0.simpChengyu.lowercased().contains(filter) ||
                $0.tradChengyu.lowercased().contains(filter) ||
                $0.definitions.joined(separator: " ").folding(options: .diacriticInsensitive, locale: nil).lowercased().contains(filter)}
        } else {
            return allChengyus
        }
    }
    
    //MARK: - Public methods
    
    override func loadView() {
        super.loadView()
        dictionnaryView = DictionnaryView(frame: view.frame)
        view = dictionnaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictionnaryView.tableView.dataSource = self
        dictionnaryView.tableView.delegate = self
        dictionnaryView.tableView.register(ChengyuTableViewCell.self, forCellReuseIdentifier: "cellID")
        dictionnaryView.tableView.separatorColor = UIColor.chengyuWhite.withAlphaComponent(0.25)
        dictionnaryView.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
    }
    
    func setupNav() {
        title = String.localize(forKey: "DICTIONNARY.TITLE")
    }
    
    //MARK: - Private methods
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension DictionnaryVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - TableView Datasource protocol methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return filteredChengyus?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "ChengyuBackground")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? ChengyuTableViewCell else {return UITableViewCell()}
            cell.chengyu = filteredChengyus?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 92
        }
        return 81
    }
    
    //MARK: - TableView Delegate protocol methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dictionnaryView.searchBar.resignFirstResponder()
        if indexPath.section == 1 {
            let nextVC = ChengyuDetailsVC()
            nextVC.chengyu = filteredChengyus?[indexPath.row]
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


extension DictionnaryVC: UISearchBarDelegate {

    //MARK: - SearchBar Delegate methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filter = searchBar.text?.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        dictionnaryView.tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filter = nil
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            filter = searchBar.text?.lowercased().folding(options: .diacriticInsensitive, locale: nil)
        }
        dictionnaryView.tableView.reloadData()
    }
}
