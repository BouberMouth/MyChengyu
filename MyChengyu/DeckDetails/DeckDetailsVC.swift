//
//  DeckDetailsVC.swift
//  I Learn Chengyus
//
//  Created by Antoine on 02/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import RealmSwift

final class DeckDetailsVC: UIViewController {
    
    //MARK: - Properties
    var allChengyus: [Chengyu]?
    var chengyus: [Chengyu]?
    var deck: Deck? {
        didSet {
            title = deck?.name
            DispatchQueue.main.async {
                self.deckDetailsView.tableView.reloadData()
            }
        }
    }
    var deckDetailsView: DictionnaryView!
    var filter: String?
    var filteredChengyus: [Chengyu]? {
        if let filter = filter {
            return chengyus?.filter {
                $0.pinyin.folding(options: .diacriticInsensitive, locale: nil).lowercased().contains(filter) ||
                    $0.chengyu.lowercased().contains(filter) ||
                    $0.definitions.joined(separator: " ").folding(options: .diacriticInsensitive, locale: nil).lowercased().contains(filter)}
        } else {
            return chengyus
        }
    }
    let realm = try! Realm()

    //MARK: - Public methods
    
    override func loadView() {
        super.loadView()
        deckDetailsView = DictionnaryView(frame: view.frame)
        view = deckDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        deckDetailsView.tableView.delegate = self
        deckDetailsView.tableView.dataSource = self
        deckDetailsView.searchBar.delegate = self
        deckDetailsView.tableView.register(ChengyuTableViewCell.self, forCellReuseIdentifier: "cellID")
        deckDetailsView.tableView.separatorColor = UIColor.chengyuWhite.withAlphaComponent(0.25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        prepareChengyus()
        deckDetailsView.tableView.reloadData()
    }
    
    func setDeck(_ deck: Deck) {
        self.deck = deck
    }
    
    //MARK: - Private methods
    
    private func prepareChengyus() {
        guard let deck = deck else { return }
        chengyus = allChengyus?.filter {deck.chengyuIndexes.contains($0.index)}
    }
}


extension DeckDetailsVC: UITableViewDelegate, UITableViewDataSource {
    //MARK: - TableView DataSource protocol methods
    
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
            //print("INDEX = \(indexPath.row)\nCHENGYU = \(filteredChengyus)\n")
            cell.chengyu = filteredChengyus?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 92
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, complete) in
            try! self.realm.write {
                self.deck!.chengyuIndexes.remove(at: indexPath.row)
            }
            self.prepareChengyus()
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = .red
        
        if let binImage = UIImage(systemName: "trash") {
            deleteAction.image = binImage
        } else {
            deleteAction.title = String.localize(forKey: "DEFAULT.DELETE")
        }
            
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    //MARK: - TableView Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        deckDetailsView.searchBar.resignFirstResponder()
        if indexPath.section == 1 {
            let nextVC = ChengyuDetailsVC()
            nextVC.chengyu = filteredChengyus?[indexPath.row]
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


extension DeckDetailsVC: UISearchBarDelegate {
    //MARK: - SearchBarDelegate protocol methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filter = searchBar.text?.folding(options: .diacriticInsensitive, locale: nil).lowercased()
        deckDetailsView.tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filter = nil
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            filter = searchBar.text?.folding(options: .diacriticInsensitive, locale: nil).lowercased()
        }
        deckDetailsView.tableView.reloadData()
    }
}
