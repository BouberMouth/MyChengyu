//
//  ChengyuDetailsVC.swift
//  I Learn Chengyus
//
//  Created by Antoine on 01/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import RealmSwift

final class ChengyuDetailsVC: UIViewController {
    
    //MARK: - Properties
    var chengyu: Chengyu?
    var chengyuDetailsView: ChengyuDetailsView!
    var decks: Results<Deck> {
        return realm.objects(Deck.self)
    }
    let realm = try! Realm()
    
    //MARK: - Public methods
    
    override func loadView() {
        super.loadView()
        chengyuDetailsView = ChengyuDetailsView(frame: view.frame)
        view = chengyuDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chengyuDetailsView.setModel(chengyu)
        chengyuDetailsView.favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        chengyuDetailsView.addButton.addTarget(self, action: #selector(addToDeck), for: .touchUpInside)
        chengyuDetailsView.copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNav()
    }
    
    //MARK: - Private methods
    
    private func setupNav() {
        title = String.localize(forKey: "CHENGYU_DETAILS.TITLE")
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addToFavorites() {
        guard let favoritesIndexes = decks.first?.chengyuIndexes else {
            return
        }
        guard let chengyu = chengyu else {
            return
        }
        if favoritesIndexes.contains(chengyu.index) {
            let indexToDelete = decks.first!.chengyuIndexes.firstIndex(of: chengyu.index)!
            try! realm.write {
                decks.first!.chengyuIndexes.remove(at: indexToDelete)
            }
            chengyuDetailsView.isFavorite = false
        } else {
            try! realm.write {
                decks.first!.chengyuIndexes.append(chengyu.index)
            }
            chengyuDetailsView.isFavorite = true
        }
    }
    
    @objc private func addToDeck() {
        let ac = UIAlertController(
            title: String.localize(forKey: "CHENGYU_DETAILS.ADD_ALERT_TITLE"),
            message: nil,
            preferredStyle: .actionSheet)
        
        for deckIndex in 1..<decks.count {
            ac.addAction(UIAlertAction(title: decks[deckIndex].name, style: .default, handler: { (action) in
                try! self.realm.write {
                    self.decks[deckIndex].addChengyuIndex(self.chengyu?.index)
                }
            }))
        }
        
        let newDeckAction = UIAlertAction(
            title: String.localize(forKey: "CHENGYU_DETAILS.ADD_ALERT_OPTION_NEW_DECK"),
            style: .default,
            handler: { (action) in
            self.createDeck()
        })
        
        let cancelAction = UIAlertAction(
            title: String.localize(forKey: "DEFAULT.CANCEL"),
            style: .cancel,
            handler: nil
        )
        
        ac.addAction(newDeckAction)
        ac.addAction(cancelAction)
        ac.setTheme()
        present(ac, animated: true)
    }
    
    @objc private func copyToClipboard() {
        guard let chengyu = chengyu else {
            return
        }
        
        let ac = UIAlertController(
            title: String.localize(forKey: "CHENGYU_DETAILS.COPY_ALERT_TITLE"),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        ac.addAction(UIAlertAction(title: chengyu.simpChengyu, style: .default, handler: { (action) in
            UIPasteboard.general.string = chengyu.simpChengyu
        }))
        ac.addAction(UIAlertAction(title: chengyu.pinyin, style: .default, handler: { (action) in
            UIPasteboard.general.string = chengyu.pinyin
        }))
        
        let cancelAction = UIAlertAction(
            title: String.localize(forKey: "DEFAULT.CANCEL"),
            style: .cancel,
            handler: nil
        )
        ac.addAction(cancelAction)
        ac.setTheme()
        present(ac, animated: true)
    }
    
    private func createDeck() {
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
