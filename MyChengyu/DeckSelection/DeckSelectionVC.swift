//
//  DeckSelectionVC.swift
//  I Learn Chengyus
//
//  Created by Antoine on 01/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import RealmSwift

final class DeckSelectionVC: UITableViewController {
    
    //MARK: - Properties
    var allChengyus: [Chengyu]?
    var decks: Results<Deck> {
        return realm.objects(Deck.self)
    }
    var deckNames: [String] {
        return decks.map {
            $0.name
        }
    }
    let realm = try! Realm()
    
    //MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(named: "ChengyuBackground")
        tableView.separatorColor = UIColor.chengyuWhite.withAlphaComponent(0.25)
        tableView.register(ChengyuDeckCell.self, forCellReuseIdentifier: "cellID")
        tableView.register(AddDeckButtonCell.self, forCellReuseIdentifier: "addCellID")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNav()
        tableView.reloadData()
    }
    
    //MARK: - Private methods
    
    private func setupNav() {
        title = String.localize(forKey: "DECK_SELECTION.TITLE")
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createDeck(_ sender: UIButton) {
        var alertTextField: UITextField!
        let ac = UIAlertController(
            title: String.localize(forKey: "DECK_SELECTION.NEW_DECK_ALERT_TITLE"),
            message: "",
            preferredStyle: .alert
        )
        ac.addTextField { (tf) in
            tf.placeholder = String.localize(forKey: "DECK_SELECTION.NEW_DECK_ALERT_TEXTFIELD_PLACEHOLDER")
            alertTextField = tf
        }
        
        let createAction = UIAlertAction(
            title: String.localize(forKey: "DECK_SELECTION.NEW_DECK_ALERT_OPTION_CREATE"),
            style: .default,
            handler: { (action) in
                if let name = alertTextField.text?.trimmingCharacters(in: [" "]), name != "" {
                    let newDeck = Deck()
                    newDeck.name = name
                    try! self.realm.write {
                        self.realm.add(newDeck)
                    }
                    self.tableView.reloadData()
            }
        })
        ac.addAction(createAction)
        
        let cancelAction = UIAlertAction(
            title: String.localize(forKey: "DEFAULT.CANCEL"),
            style: .cancel,
            handler: nil
        )
        ac.addAction(cancelAction)
        ac.setTheme()
        present(ac, animated: true)
    }
}


extension DeckSelectionVC {
    //MARK: - TableViewDatasource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return decks.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? ChengyuDeckCell else {
                return UITableViewCell()
            }
            cell.nameLabel.text = decks[indexPath.row].name
            cell.numberLabel.text = "\(decks[indexPath.row].chengyuIndexes.count) chengyus"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addCellID", for: indexPath) as? AddDeckButtonCell else {
                return UITableViewCell()
            }
            cell.button.addTarget(self, action: #selector(createDeck), for: .touchUpInside)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, complete) in
            try! self.realm.write {
                self.realm.delete(self.decks[indexPath.row])
            }
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
    
    //MARK: - TableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let nextVC = DeckDetailsVC()
            nextVC.setDeck(decks[indexPath.row])
            nextVC.allChengyus = allChengyus
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}


