//
//  GameRecordsVC.swift
//  I Learn Chengyus
//
//  Created by Antoine on 02/04/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit
import RealmSwift

final class GameRecordsVC: UITableViewController {
    
    let realm = try! Realm()
    lazy var records: Results<GameRecord> = {
        realm.objects(GameRecord.self)
    }()

    var newRecordID: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(named: "ChengyuBackground")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.separatorColor = UIColor.chengyuWhite.withAlphaComponent(0.25)
        title = String.localize(forKey: "GAME_RECORDS.TITLE")
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(backToMenu))
    }
    
    @objc private func backToMenu() {
        navigationController?.popToRootViewController(animated: true)
        ReviewService.shared.increaseCompletedProcesses()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String.localize(forKey: "GAME_RECORDS.LIST_DATE_FORMAT")
        let date = dateFormatter.string(from: records[indexPath.row].date)
        let score = records[indexPath.row].score
        cell.textLabel?.text = "\(date) (\(score)%)"
        cell.backgroundColor = newRecordID == records[indexPath.row].id ? UIColor(named: "ChengyuBackgroundNegative")?.withAlphaComponent(0.5) : UIColor(named: "ChengyuBackground")
        cell.textLabel?.textColor = .chengyuWhite
        cell.textLabel?.font = UIFont.roundedFont(ofSize: 20.0, weight: .regular)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, complete) in
            try! self.realm.write {
                let itemToDelete = self.records[indexPath.row]
                self.realm.delete(itemToDelete)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let record = records[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = String.localize(forKey: "GAME_RECORDS.DETAILS_DATE_FORMAT")
        let date = dateFormatter.string(from: record.date)
        
        let body = """
        
        \(String.localize(forKey: "GAME_RECORDS.DETAILS_PLACEHOLDER.DATE")) : \(date)
        
        \(String.localize(forKey: "GAME_RECORDS.DETAILS_PLACEHOLDER.DECK_NAME")) : \(record.deckName)
        
        \(String.localize(forKey: "GAME_RECORDS.DETAILS_PLACEHOLDER.RIGHT_ANSWERS")) : \(record.goodAnswers)
        
        \(String.localize(forKey: "GAME_RECORDS.DETAILS_PLACEHOLDER.WRONG_ANSWERS")) : \(record.wrongAnswers)
        
        \(String.localize(forKey: "GAME_RECORDS.DETAILS_PLACEHOLDER.SCORE")) : \(record.score)%
        """

        let ac = UIAlertController(title: String.localize(forKey: "GAME_RECORDS.DETAILS_ALERT_TITLE"), message: body, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: String.localize(forKey: "DEFAULT.OK"), style: .cancel, handler: nil))
        ac.setTheme()
        present(ac, animated: true)
    }
    
    
}
