//
//  GameSettingsVC.swift
//  I Learn Chengyus
//
//  Created by Antoine on 10/03/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import RealmSwift

final class GameSettingsVC: UITableViewController {
    //MARK: - Properties
    var allChengyus: [Chengyu]?
    var decks: Results<Deck> {
        return realm.objects(Deck.self)
    }
    var deckSelection: [Deck]? {
        guard let allChengyus = allChengyus else {
            return nil
        }
        return [Deck.createDeckWith(allChengyus)] + decks
    }
    let realm = try! Realm()
    var selectedDeckIndex: Int?
    var selectedLevel: Level?

    //MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNav()
        tableView.register(ChengyuDeckCell.self, forCellReuseIdentifier: "deckCellID")
        tableView.register(LevelSelectionCell.self, forCellReuseIdentifier: "levelCellID")
    }
    
    //MARK: - Private methods
    
    private func setupNav() {
        navigationController?.isNavigationBarHidden = false
        title = String.localize(forKey: "GAME_SETTINGS.TITLE")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: String.localize(forKey: "GAME_SETTINGS.START_BUTTON"),
            style: .done,
            target: self,
            action: #selector(startGame)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupView() {
        tableView.backgroundColor = UIColor(named: "ChengyuBackground")
        tableView.separatorColor = UIColor.chengyuWhite.withAlphaComponent(0.25)
        tableView.tableFooterView = UIView()
        tableView.headerView(forSection: 0)?.tintColor = .green
    }
    
    @objc private func startGame() {
        guard let index = selectedDeckIndex, let deck = deckSelection?[index] else {return}
        guard let nextChengyus = allChengyus?.filter({deck.chengyuIndexes.contains($0.index)}) else {return}
        guard let nextLevel = selectedLevel else {return}
        if nextLevel.intValue() > nextChengyus.count {
            presentTooFewChengyusAC(minNumberRequired: nextLevel.intValue())
        } else {
            let nextVC = GameVC()
            nextVC.game = Game(chengyus: nextChengyus, level: nextLevel)
            nextVC.selectedDeckName = deck.name
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    private func presentTooFewChengyusAC(minNumberRequired: Int) {
        let ac = UIAlertController(
            title: String.localize(forKey: "GAME_SETTINGS.ALERT_TITLE"),
            message: String.localize(forKey: "GAME_SETTINGS.ALERT_MESSAGE").replacingOccurrences(of: "%INT%", with: String(minNumberRequired)),
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(
            title: String.localize(forKey: "DEFAULT.OK"),
            style: .default,
            handler: { (action) in
                self.dismiss(animated: true, completion: nil)
        }))
        ac.setTheme()
        present(ac, animated: true)
    }
}


extension GameSettingsVC {
    //MARK: - TableView datasource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return deckSelection?.count ?? 0
        } else {
            return Level.allCases.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "deckCellID", for: indexPath) as? ChengyuDeckCell else {
                return UITableViewCell()
            }
            let name = deckSelection?[indexPath.row].name
            cell.nameLabel.text = name
            let chengyuCount = deckSelection?[indexPath.row].chengyuIndexes.count ?? 0
            var numLabel = "\(chengyuCount) "
            numLabel += String.localize(forKey: chengyuCount < 2 ? "DEFAULT.CHENGYU" : "DEFAULT.CHENGYUS")
            cell.numberLabel.text = numLabel
            cell.iconImageView.image = nil
            cell.tintColor = .chengyuWhite
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "levelCellID", for: indexPath) as? LevelSelectionCell else {
                return UITableViewCell()
            }
            cell.textLabel?.text = Level.allCases[indexPath.row].stringValue()
            cell.tintColor = .chengyuWhite
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 32))
        let label = UILabel(frame: CGRect(x: 8, y: 8, width: tableView.frame.width - 16, height: 24))
        label.textColor = .chengyuWhite
        label.font = UIFont.roundedFont(ofSize: 17, weight: .regular)
        label.layer.borderColor = UIColor.chengyuWhite.cgColor
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.layer.cornerRadius = label.frame.height / 2
        switch section {
        case 0:
            label.text = String.localize(forKey: "GAME_SETTINGS.SELECT_DECK")
        case 1:
            label.text = String.localize(forKey: "GAME_SETTINGS.SELECT_LEVEL")
        default:
            break
        }
        
        view.addSubview(label)
        view.backgroundColor = UIColor(named: "ChengyuBackground")
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}

extension GameSettingsVC {
    //MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if selectedDeckIndex == nil || selectedDeckIndex != indexPath.row {
                if let lastIndex = selectedDeckIndex {
                    tableView.cellForRow(at: IndexPath(row: lastIndex, section: 0))?.accessoryType = .none
                }
                selectedDeckIndex = indexPath.row
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            } else {
                selectedDeckIndex = nil
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
        } else {
            if selectedLevel == nil || selectedLevel != Level.allCases[indexPath.row] {
                if let level = selectedLevel, let lastIndex = Level.allCases.firstIndex(of: level) {
                    tableView.cellForRow(at: IndexPath(row: lastIndex, section: 1))?.accessoryType = .none
                }
                selectedLevel = Level.allCases[indexPath.row]
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            } else {
                selectedLevel = nil
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
            
        }
        navigationItem.rightBarButtonItem?.isEnabled = (selectedLevel != nil) && (selectedDeckIndex != nil)
    }
}
